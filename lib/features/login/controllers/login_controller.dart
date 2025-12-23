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
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleAutoLogin() => isAutoLogin.value = !isAutoLogin.value;

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
          "remember_me": isAutoLogin.value,
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(utf8.decode(loginResponse.bodyBytes));

        await box.write('access_token', loginData['access_token']);
        await box.write('refresh_token', loginData['refresh_token']);
        await box.write('is_auto_login', isAutoLogin.value);
        await box.remove('is_taste_analyzed_local');

        print("✅ 로그인 성공");

        final appController = Get.find<AppController>();
        await appController.fetchUserProfile();

        // 재진입 시 데이터 갱신을 위해 기존 컨트롤러 삭제
        if (Get.isRegistered<MyReadController>()) {
          Get.delete<MyReadController>();
        }

        final profile = appController.userProfile;
        bool isAnalyzed = profile['taste_analyzed'] ?? false;

        if (isAnalyzed) {
          // ✅ [수정완료] 로그인 성공 시 무조건 홈(0번 탭)으로 설정!
          appController.changeIndex(0);

          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }

      } else {
        passwordError.value = "이메일 혹은 비밀번호를 확인해주세요.";
      }
    } catch (e) {
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() => Get.toNamed(Routes.signUp);
  void goToForgetPassword() => Get.toNamed(Routes.forgetPassword);
}