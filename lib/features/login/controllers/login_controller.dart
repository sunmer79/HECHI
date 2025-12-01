import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart'; // ✅ 저장소 추가

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // 서버 주소
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage(); // ✅ 저장소 인스턴스

  @override
  void onInit() {
    super.onInit();
    // 에러 메시지 초기화 리스너
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
    String email = emailController.text;
    String password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true;

    try {
      // 1️⃣ 로그인 요청
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

        // ✅ [핵심] 토큰 저장! (앱 껐다 켜도 유지됨)
        await box.write('access_token', accessToken);
        print("✅ 1. 로그인 성공! 토큰 저장됨");

        // 2️⃣ 내 정보 요청 (취향 분석 여부 확인용)
        final meUrl = Uri.parse('$baseUrl/auth/me');
        final meResponse = await http.get(
          meUrl,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken" // 저장한 토큰 사용
          },
        );

        if (meResponse.statusCode == 200) {
          final meData = jsonDecode(meResponse.body);

          // 1. 서버 데이터 확인 (taste_analyzed 필드)
          bool serverSaysDone = meData['taste_analyzed'] ?? false;

          // 2. 로컬 데이터 이중 체크 (혹시 서버 동기화 늦을 때를 대비)
          bool localSaysDone = box.read('is_taste_analyzed_local') ?? false;

          print("✅ 2. 내 정보 확인: 서버($serverSaysDone) / 로컬($localSaysDone)");

          // 3️⃣ 화면 분기 처리
          if (serverSaysDone || localSaysDone) {
            // 이미 분석했으면 -> 메인 홈으로
            Get.offAllNamed(Routes.initial);
          } else {
            // 안 했으면 -> 취향 분석 페이지로
            Get.offAllNamed(Routes.preference);
          }
        } else {
          print("❌ 내 정보 조회 실패: ${meResponse.body}");
          // 정보 조회 실패 시 안전하게 취향 분석으로 이동 (혹은 에러 처리)
          Get.offAllNamed(Routes.preference);
        }

      } else {
        print("❌ 로그인 실패: ${loginResponse.body}");
        passwordError.value = "이메일(아이디) 혹은 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar(
          "오류",
          "서버와 연결할 수 없습니다.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderColor: Colors.grey[300],
          borderWidth: 1
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