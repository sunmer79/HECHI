import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class PreferenceController extends GetxController {
  RxInt currentStep = 0.obs;

  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> selectedGenres = <String>[].obs;

  RxList<String> categories = <String>[].obs;
  RxList<String> genres = <String>[].obs;

  RxBool isLoading = false.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  // ✅ [수정됨] 1. 제거할 장르/카테고리 목록 정의
  final List<String> excludedItems = ['스릴러/공포', '스릴러', '공포', 'SF', '판타지', '시'];

  @override
  void onInit() {
    super.onInit();
    _fetchOptions();
    Future.delayed(const Duration(seconds: 2), () {
      if (currentStep.value == 0) nextStep();
    });
  }

  Future<void> _fetchOptions() async {
    try {
      final url = Uri.parse('$baseUrl/taste/options');
      String? token = box.read('access_token');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        // 원본 리스트 가져오기
        List<String> rawCategories = List<String>.from(data['categories'] ?? []);
        List<String> rawGenres = List<String>.from(data['genres'] ?? []);

        // ✅ [수정됨] 2. API 데이터에서 제외할 항목 필터링 (Where 로직)
        // 리스트에 있는 단어와 정확히 일치하면 제거합니다.
        categories.value = rawCategories
            .where((item) => !excludedItems.contains(item))
            .toList();

        genres.value = rawGenres
            .where((item) => !excludedItems.contains(item))
            .toList();

      } else {
        _useFallbackData();
      }
    } catch (e) {
      _useFallbackData();
    }
  }

  void _useFallbackData() {
    // ✅ [수정됨] 3. 기본 데이터에서도 '시', '스릴러', '공포', 'SF', '판타지' 제거
    categories.value = ['소설', '에세이', '만화']; // '시' 제거됨
    genres.value = [
      '추리', '코미디', // '스릴러', '공포', 'SF', '판타지' 제거됨
      '로맨스', '액션', '철학', '인문', '역사',
      '과학', '예술', '자기계발', '여행', '취미'
    ];
  }

  void nextStep() {
    // 1단계: 카테고리 (최소 1개)
    if (currentStep.value == 1) {
      if (selectedCategories.isEmpty) {
        _showError("카테고리를 최소 1개 선택해주세요.");
        return;
      }
    }
    // 2단계: 장르 (최소 1개)
    else if (currentStep.value == 2) {
      if (selectedGenres.isEmpty) {
        _showError("장르를 최소 1개 선택해주세요.");
        return;
      }
      submitPreferences();
      return;
    }

    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }


  void toggleCategory(String item) {
    if (selectedCategories.contains(item)) {
      selectedCategories.remove(item);
    } else {
      selectedCategories.add(item);
    }
  }


  void toggleGenre(String item) {
    if (selectedGenres.contains(item)) {
      selectedGenres.remove(item);
    } else {
      selectedGenres.add(item);
    }
  }

  void _showError(String msg) {
    Get.snackbar("알림", msg,
        backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  Future<void> submitPreferences() async {
    isLoading.value = true;
    String? token = box.read('access_token');

    if (token == null) {
      Get.offAllNamed(Routes.login);
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/taste/submit');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "categories": selectedCategories.toList(),
          "genres": selectedGenres.toList()
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await box.write('is_taste_analyzed_local', true);
        Get.offAllNamed(Routes.initial);
        Get.snackbar("환영합니다!", "취향 분석이 완료되었습니다.",
            backgroundColor: const Color(0xFF4DB56C), colorText: Colors.white);
      } else {
        _showError("저장에 실패했습니다. (${response.statusCode})");
      }
    } catch (e) {
      _showError("서버와 연결할 수 없습니다.");
    } finally {
      isLoading.value = false;
    }
  }
}