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

  // ✅ [신규] 자동 로그인 체크박스 상태
  RxBool isAutoLogin = false.obs;

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

  // ✅ [신규] 체크박스 토글 함수
  void toggleAutoLogin() => isAutoLogin.value = !isAutoLogin.value;

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
      final loginUrl = Uri.parse('$baseUrl/auth/login');
      final loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "remember_me": isAutoLogin.value, // API에 상태 전달
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(utf8.decode(loginResponse.bodyBytes));
        String accessToken = loginData['access_token'];
        String refreshToken = loginData['refresh_token']; // 있으면 저장

        // ✅ [핵심] 토큰 및 자동 로그인 설정 저장
        await box.write('access_token', accessToken);
        await box.write('refresh_token', refreshToken);
        await box.write('is_auto_login', isAutoLogin.value); // 체크박스 상태 저장

        // 이전 로컬 데이터 정리
        await box.remove('is_taste_analyzed_local');

        print("✅ 로그인 성공 (자동 로그인 설정: ${isAutoLogin.value})");

        await _checkTasteAnalysisAndRedirect(accessToken);

      } else {
        print("❌ 로그인 실패: ${loginResponse.body}");
        passwordError.value = "이메일 혹은 비밀번호를 확인해주세요.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.");
    } finally {
      isLoading.value = false;
    }
  }

  // 라우팅 로직 (기존 동일)
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
        final meData = jsonDecode(utf8.decode(meResponse.bodyBytes));
        bool isAnalyzed = meData['taste_analyzed'] ?? false;

        if (isAnalyzed) {
          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }
      } else {
        Get.offAllNamed(Routes.preference);
      }
    } catch (e) {
      Get.offAllNamed(Routes.preference);
    }
  }

  void goToSignUp() => Get.toNamed(Routes.signUp);
  void goToForgetPassword() => Get.toNamed(Routes.forgetPassword);
}