import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      if (emailError.isNotEmpty) emailError.value = '';
    });
    passwordController.addListener(() {
      if (passwordError.isNotEmpty) passwordError.value = '';
    });
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  // 🔐 로그인 로직
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }
    if (password.isEmpty) {
      passwordError.value = "비밀번호를 입력해주세요.";
      return;
    }

    isLoading.value = true;

    try {
      // 1. 로그인 요청
      final loginUrl = Uri.parse('$baseUrl/auth/login');
      final loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(loginResponse.body);
        String accessToken = loginData['access_token'];

        // ✅ 토큰 저장
        await box.write('access_token', accessToken);

        // ✅ [중요] 새 사용자로 로그인했으므로, 이전 사용자의 '로컬 취향 분석 기록'은 삭제합니다.
        // 이것 때문에 계속 메인으로 넘어갔던 것입니다.
        await box.remove('is_taste_analyzed_local');

        print("✅ 1. 로그인 성공 (이전 로컬 기록 삭제 완료)");

        // 2. 내 정보 확인 및 라우팅 (서버 데이터 기준)
        await _checkTasteAnalysisAndRedirect(accessToken);

      } else {
        print("❌ 로그인 실패: ${loginResponse.body}");
        passwordError.value = "이메일 혹은 비밀번호를 확인해주세요.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar(
        "오류",
        "서버와 연결할 수 없습니다.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🚀 라우팅 분기 처리
  Future<void> _checkTasteAnalysisAndRedirect(String token) async {
    try {
      final meUrl = Uri.parse('$baseUrl/auth/me');
      final meResponse = await http.get(
        meUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (meResponse.statusCode == 200) {
        final meData = jsonDecode(meResponse.body);
        print("✅ 2. 내 정보 조회 결과: $meData");

        // ✅ [핵심 수정] 오직 서버 데이터(taste_analyzed)만 신뢰합니다.
        // 로컬 변수(|| box.read...)를 제거하여 꼬임을 방지합니다.
        bool isAnalyzed = meData['taste_analyzed'] ?? false;

        print("🧐 서버 판단: 취향 분석 여부 = $isAnalyzed");

        if (isAnalyzed) {
          print("🚀 -> 메인으로 이동 (Routes.initial)");
          Get.offAllNamed(Routes.initial);
        } else {
          print("🚀 -> 취향 분석으로 이동 (Routes.preference)");
          Get.offAllNamed(Routes.preference);
        }

      } else {
        print("❌ 내 정보 조회 실패, 안전하게 취향 분석 페이지로 이동");
        Get.offAllNamed(Routes.preference);
      }
    } catch (e) {
      print("🚨 오류 발생: $e, 취향 분석 페이지로 이동");
      Get.offAllNamed(Routes.preference);
    }
  }

  void goToSignUp() {
    Get.toNamed(Routes.signUp);
  }

  void goToForgetPassword() {
    Get.toNamed(Routes.forgetPassword);
  }
}