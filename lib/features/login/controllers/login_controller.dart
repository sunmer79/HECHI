import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs; // 로딩 상태

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // ✅ 실제 서버 주소 (https 적용)
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  @override
  void onInit() {
    super.onInit();
    // 입력 시 에러 메시지 초기화
    emailController.addListener(() {
      if (emailError.isNotEmpty) emailError.value = '';
    });
    passwordController.addListener(() {
      if (passwordError.isNotEmpty) passwordError.value = '';
    });
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  // 🔐 진짜 로그인 로직 (API 연동)
  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // 1. 로컬 유효성 검사
    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true; // 로딩 시작

    try {
      // 2. 서버 요청
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // 3. 응답 처리
      if (response.statusCode == 200) {
        print("✅ 로그인 성공: ${response.body}");
        // (토큰 저장 로직은 추후 추가 가능)
        Get.offAllNamed(Routes.initial);
      } else {
        print("❌ 로그인 실패: ${response.body}");
        // 에러 메시지 설정
        passwordError.value = "이메일(아이디) 혹은 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  void goToSignUp() {
    Get.toNamed(Routes.signUp);
  }

  void goToForgetPassword() {
    // 3단계에서 연결 예정 (지금은 주석 처리)
    // Get.toNamed(Routes.forgetPassword);
  }
}