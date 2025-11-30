import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isEmailFilled = false.obs;
  Rxn<bool> isEmailAvailable = Rxn<bool>();
  RxString emailStatusMessage = ''.obs;
  RxBool isLoading = false.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      isEmailFilled.value = emailController.text.isNotEmpty;
      if (isEmailAvailable.value != null) {
        isEmailAvailable.value = null;
        emailStatusMessage.value = '';
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  // 이메일 형식 검사 (중복 확인 API 없음)
  void checkEmailDuplicate() {
    if (!isEmailFilled.value) return;
    if (!GetUtils.isEmail(emailController.text)) {
      isEmailAvailable.value = false;
      emailStatusMessage.value = '이메일 형식이 올바르지 않습니다.';
    } else {
      isEmailAvailable.value = true;
      emailStatusMessage.value = '사용 가능한 이메일 형식입니다.';
    }
  }

  // 🚀 진짜 회원가입
  Future<void> submitSignUp() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty ||
        nameController.text.isEmpty || nicknameController.text.isEmpty) {
      Get.snackbar("알림", "모든 정보를 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isEmailAvailable.value != true) {
      Get.snackbar("알림", "이메일 중복 확인을 해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/auth/register');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "name": nameController.text,
          "nickname": nicknameController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 가입 성공: ${response.body}");
        Get.snackbar("환영합니다!", "가입이 완료되었습니다. 로그인해주세요.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black87, colorText: Colors.white);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(Routes.login);
        });
      } else {
        print("❌ 가입 실패: ${response.body}");
        Get.snackbar("가입 실패", "입력하신 정보를 확인해주세요.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}