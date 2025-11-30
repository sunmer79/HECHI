import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";

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

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 로그인 성공: ${response.body}");
        final responseData = jsonDecode(response.body);
        bool isTasteAnalyzed = responseData['taste_analyzed'] ?? false;

        if (isTasteAnalyzed) {
          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }

      } else {
        print("❌ 로그인 실패: ${response.body}");
        passwordError.value = "이메일(아이디) 혹은 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      // ✅ 스낵바 디자인 변경 (흰 배경, 검은 글씨)
      Get.snackbar(
        "오류", "서버와 연결할 수 없습니다.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderColor: Colors.grey[300],
        borderWidth: 1,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.toNamed(Routes.signUp);
  }

  void goToForgetPassword() {
    Get.toNamed(Routes.forgetPassword);
  }
}