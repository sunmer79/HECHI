import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import '../../my_read/controllers/my_read_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;
  RxBool isAutoLogin = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    // 🚨 [핵심 수정] 화면 빌드가 끝난 후 리스너 등록 (Render 에러 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailController.addListener(() {
        if (emailError.isNotEmpty) emailError.value = '';
      });
      passwordController.addListener(() {
        if (passwordError.isNotEmpty) passwordError.value = '';
      });
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleAutoLogin() => isAutoLogin.value = !isAutoLogin.value;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 간단 유효성 검사
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
          "remember_me": isAutoLogin.value,
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(utf8.decode(loginResponse.bodyBytes));
        String accessToken = loginData['access_token'];
        String refreshToken = loginData['refresh_token'];

        // 토큰 저장
        await box.write('access_token', accessToken);
        await box.write('refresh_token', refreshToken);
        await box.write('is_auto_login', isAutoLogin.value);

        // 로컬 캐시 정리
        await box.remove('is_taste_analyzed_local');

        print("✅ 로그인 성공, 유저 정보 동기화 시작...");

        // 앱 컨트롤러에 유저 정보 로드 요청
        final appController = Get.find<AppController>();
        await appController.fetchUserProfile();

        // ✅ MyReadController 초기화 (재진입 시 데이터 갱신을 위해)
        if (Get.isRegistered<MyReadController>()) {
          Get.delete<MyReadController>();
        }

        // 취향 분석 여부에 따라 이동
        final profile = appController.userProfile;
        bool isAnalyzed = profile['taste_analyzed'] ?? false;

        if (isAnalyzed) {
          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }

      } else {
        print("❌ 로그인 실패: ${loginResponse.body}");
        passwordError.value = "이메일 혹은 비밀번호를 확인해주세요.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() => Get.toNamed(Routes.signUp);
  void goToForgetPassword() => Get.toNamed(Routes.forgetPassword);
}