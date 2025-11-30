import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

class PreferenceController extends GetxController {
  // ✅ [핵심] 현재 단계 (0: 인트로, 1: 카테고리, 2: 장르)
  RxInt currentStep = 0.obs;

  // 선택된 데이터 저장소
  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> selectedGenres = <String>[].obs;

  // 데이터 목록
  final categories = ['소설', '시', '에세이', '만화'];
  final genres = [
    '추리', '코미디', '스릴러/공포', 'SF', '판타지', '로맨스',
    '액션', '철학', '인문', '역사', '과학', '사회/정치',
    '경제/경영', '예술', '자기계발', '여행', '취미'
  ];

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

  // ✅ [핵심] 다음 단계로 이동하는 함수
  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++; // 숫자 증가 (화면 바뀜)
    } else {
      submitPreferences(); // 마지막 단계면 저장
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

  // 완료 및 팝업 띄우기
  void submitPreferences() {
    print("선택된 카테고리: $selectedCategories");
    print("선택된 장르: $selectedGenres");

    // 예쁜 팝업창 띄우기
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DB56C),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '취향 분석 완료!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'HECHI에 오신 걸 환영합니다!',
                  style: TextStyle(fontSize: 15, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.offAllNamed(Routes.initial);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4DB56C),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '홈으로 가기',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}