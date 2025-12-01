import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class PreferenceController extends GetxController {
  // 현재 단계 (0: 인트로, 1: 카테고리, 2: 장르)
  RxInt currentStep = 0.obs;

  // 선택된 데이터 저장소
  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> selectedGenres = <String>[].obs;

  // 화면에 보여줄 데이터
  final categories = ['소설', '시', '에세이', '만화'];
  final genres = [
    '추리', '코미디', '스릴러/공포', 'SF', '판타지', '로맨스',
    '액션', '철학', '인문', '역사', '과학', '사회/정치',
    '경제/경영', '예술', '자기계발', '여행', '취미'
  ];

  // 서버 주소
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 0단계(인트로)는 2초 뒤 자동으로 1단계로 넘어감
    Future.delayed(const Duration(seconds: 2), () {
      if (currentStep.value == 0) {
        nextStep();
      }
    });
  }

  // 다음 단계로 이동 (최소 1개 선택 검증 로직 추가)
  void nextStep() {
    // 1단계 -> 2단계로 넘어갈 때 (카테고리 선택 검증)
    if (currentStep.value == 1) {
      if (selectedCategories.isEmpty) {
        _showSelectionError("카테고리를 최소 1개 이상 선택해주세요.");
        return; // 검증 실패 시 다음 단계로 진행하지 않음
      }
    }
    // 2단계 (마지막 단계)
    else if (currentStep.value == 2) {
      // 2단계에서 '완료' 버튼을 눌렀을 때 (장르 선택 검증)
      if (selectedGenres.isEmpty) {
        _showSelectionError("장르를 최소 1개 이상 선택해주세요.");
        return; // 검증 실패 시 제출하지 않음
      }

      submitPreferences(); // 검증 통과 시 취향 정보 제출
      return;
    }

    // 0단계에서 1단계로 이동하거나, 검증에 통과했을 때 단계 증가
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  // 카테고리 선택 토글
  void toggleCategory(String item) {
    if (selectedCategories.contains(item)) {
      selectedCategories.remove(item);
    } else {
      selectedCategories.add(item);
    }
  }

  // 장르 선택 토글
  void toggleGenre(String item) {
    if (selectedGenres.contains(item)) {
      selectedGenres.remove(item);
    } else {
      selectedGenres.add(item);
    }
  }

  // 에러 메시지 스낵바 표시
  void _showSelectionError(String message) {
    Get.snackbar(
      "선택 필요",
      message,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  // 🚀 [진짜 API 연결] 취향 정보 제출
  Future<void> submitPreferences() async {
    // nextStep()에서 이미 검증했으나, 안전을 위해 최종 검증
    if (selectedCategories.isEmpty || selectedGenres.isEmpty) {
      _showSelectionError("카테고리와 장르를 최소 1개씩 선택해주세요.");
      return;
    }

    isLoading.value = true;

    try {
      // 1. 저장해둔 토큰 꺼내기
      String? token = box.read('access_token');

      if (token == null) {
        print("🚨 토큰이 없습니다. 로그인부터 다시 해주세요.");
        Get.offAllNamed(Routes.login);
        return;
      }

      // 2. 진짜 API 주소 (/taste/submit)
      final url = Uri.parse('$baseUrl/taste/submit');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "categories": selectedCategories,
          "genres": selectedGenres
        }),
      );

      // 3. 응답 확인
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 취향 저장 성공!");

        // ✅ [핵심] 로컬 저장소에도 '완료함' 표시 (다음 로그인 시 체크용)
        await box.write('is_taste_analyzed_local', true);

        // 성공 팝업
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFF4DB56C), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.check, color: Colors.white, size: 16)),
                      const SizedBox(width: 10),
                      const Text('취향 분석 완료!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F), fontFamily: 'Roboto')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(width: double.infinity, child: Text('HECHI에 오신 걸 환영합니다!', style: TextStyle(fontSize: 15, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'))),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Get.back(); // 팝업 닫기
                      Get.offAllNamed(Routes.initial); // 홈으로 이동
                    },
                    child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF4DB56C), borderRadius: BorderRadius.circular(25)), alignment: Alignment.center, child: const Text('홈으로 가기', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        print("❌ 취향 저장 실패: ${response.body}");
        Get.snackbar("오류", "저장에 실패했습니다. 다시 시도해주세요.", backgroundColor: Colors.white);
      }
    } catch (e) {
      print("통신 오류: $e");
      Get.snackbar("오류", "서버 연결 실패", backgroundColor: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}