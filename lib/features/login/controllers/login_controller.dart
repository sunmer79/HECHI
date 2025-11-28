import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isEmailFilled = false.obs;
  RxBool isPasswordFilled = false.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      isEmailFilled.value = emailController.text.isNotEmpty;
      if (emailError.isNotEmpty) emailError.value = '';
    });
    passwordController.addListener(() {
      isPasswordFilled.value = passwordController.text.isNotEmpty;
      if (passwordError.isNotEmpty) passwordError.value = '';
    });
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }
    if (email != "HECHI@kmu.ac.kr") {
      emailError.value = "가입되지 않은 이메일입니다. 회원가입을 진행해주세요.";
      return;
    }
    if (password != "#password2468") {
      passwordError.value = "비밀번호가 틀렸습니다.";
      return;
    }
    // 로그인 성공 시 이동
    Get.offAllNamed(Routes.initial);
  }

  void goToSignUp() {
    // 2단계에서 구현 (지금은 주석)
    // Get.toNamed(Routes.signUp);
  }

  void goToForgetPassword() {
    // 3단계에서 구현 (지금은 주석)
    // Get.toNamed(Routes.forgetPassword);
  }
}