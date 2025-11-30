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

  // 서버 주소
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

  // 🔐 로그인 로직 (로그인 -> 내 정보 확인 -> 이동)
  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true;

    try {
      // 1️⃣ 로그인 요청 (POST /auth/login)
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
        print("✅ 1. 로그인 성공! 토큰 획득");

        // 2️⃣ 내 정보 요청 (GET /auth/me) - 취향 분석 여부 확인
        final meUrl = Uri.parse('$baseUrl/auth/me');
        final meResponse = await http.get(
          meUrl,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken" // 토큰을 헤더에 담아 보냄
          },
        );

        if (meResponse.statusCode == 200) {
          final meData = jsonDecode(meResponse.body);
          // taste_analyzed 값 확인 (없으면 false)
          bool isTasteAnalyzed = meData['taste_analyzed'] ?? false;
          print("✅ 2. 내 정보 확인 완료: 취향분석=$isTasteAnalyzed");

          // 3️⃣ 분기 처리
          if (isTasteAnalyzed) {
            Get.offAllNamed(Routes.initial); // 홈으로
          } else {
            Get.offAllNamed(Routes.preference); // 취향 분석으로
          }
        } else {
          print("❌ 내 정보 조회 실패: ${meResponse.body}");
          // 정보 조회가 안 되면 일단 홈으로 보내거나 에러 표시
          // 여기선 일단 안전하게 홈으로 보냅니다 (필요시 수정 가능)
          Get.offAllNamed(Routes.initial);
        }

      } else {
        print("❌ 로그인 실패: ${loginResponse.body}");
        passwordError.value = "이메일(아이디) 혹은 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, colorText: Colors.black, borderColor: Colors.grey[300], borderWidth: 1);
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