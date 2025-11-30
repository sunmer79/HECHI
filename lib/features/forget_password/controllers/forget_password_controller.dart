import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordController extends GetxController {
  // 텍스트 컨트롤러
  final emailController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  // 상태 변수
  RxBool isEmailFilled = false.obs;
  RxString emailError = ''.obs;
  RxBool isNewPassFilled = false.obs;
  RxBool isConfirmPassFilled = false.obs;
  RxBool isConfirmHidden = true.obs;
  RxInt currentStep = 0.obs;
  RxBool isLoading = false.obs;

  // 서버 주소
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      isEmailFilled.value = emailController.text.isNotEmpty;
      if (emailError.isNotEmpty) emailError.value = '';
    });
    newPassController.addListener(() => isNewPassFilled.value = newPassController.text.isNotEmpty);
    confirmPassController.addListener(() => isConfirmPassFilled.value = confirmPassController.text.isNotEmpty);
  }

  @override
  void onClose() {
    emailController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }

  void toggleConfirmVisibility() => isConfirmHidden.value = !isConfirmHidden.value;

  // 1단계: 비밀번호 재설정 요청
  Future<void> requestPasswordReset() async {
    String email = emailController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/auth/password-reset/request');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        print("✅ 요청 성공: ${response.body}");
        currentStep.value = 1;
      } else {
        print("❌ 요청 실패: ${response.body}");
        emailError.value = "가입되지 않은 이메일입니다.";
      }
    } catch (e) {
      Get.snackbar("오류", "서버 연결 실패", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, colorText: Colors.black, borderColor: Colors.grey[300], borderWidth: 1);
    } finally {
      isLoading.value = false;
    }
  }

  // 2단계: 비밀번호 변경 (팝업 적용됨)
  Future<void> confirmPasswordReset() async {
    if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) return;

    if (newPassController.text != confirmPassController.text) {
      Get.snackbar("오류", "비밀번호가 일치하지 않습니다.", backgroundColor: Colors.white, colorText: const Color(0xFFEA1717), snackPosition: SnackPosition.BOTTOM, borderColor: Colors.grey[300], borderWidth: 1);
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/auth/password-reset/confirm');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "new_password": newPassController.text
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 변경 성공: ${response.body}");

        // ✨ [디자인 적용] 비밀번호 변경 성공 팝업
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DB56C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '비밀번호 변경 성공!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '비밀번호가 변경되었습니다.\n로그인을 진행해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(Routes.login);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DB56C),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        '로그인하러 가기',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("실패", "비밀번호 변경에 실패했습니다.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, colorText: Colors.black, borderColor: Colors.grey[300], borderWidth: 1);
      }
    } catch (e) {
      Get.snackbar("오류", "서버 연결 실패", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white, colorText: Colors.black, borderColor: Colors.grey[300], borderWidth: 1);
    } finally {
      isLoading.value = false;
    }
  }
}