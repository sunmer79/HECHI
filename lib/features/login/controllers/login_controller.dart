import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;

  // 입력 감지용 (별표 숨기기)
  RxBool isEmailFilled = false.obs;
  RxBool isPasswordFilled = false.obs;

  // ✅ 에러 메시지 분리 (각각의 위치에 띄우기 위해)
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 입력할 때마다 해당 필드의 에러 메시지 초기화
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

    // 1. 이메일 형식 검사
    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    // 2. 가입된 이메일인지 확인 (요청하신 아이디로 변경)
    if (email != "HECHI@kmu.ac.kr") {
      emailError.value = "가입되지 않은 이메일입니다. 회원가입을 진행해주세요.";
      return;
    }

    // 3. 비밀번호 확인 (요청하신 비밀번호로 변경)
    if (password != "#password2468") {
      passwordError.value = "비밀번호가 틀렸습니다.";
      return;
    }

    // 로그인 성공 -> 홈으로 이동
    Get.offAllNamed('/home');
  }

  void goToSignUp() {
    // Get.toNamed('/sign_up');
  }

  void goToForgetPassword() {
    // Get.toNamed('/forget_password');
  }
}