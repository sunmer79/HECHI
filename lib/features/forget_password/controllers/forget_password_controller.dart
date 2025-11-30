import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordController extends GetxController {
  // UI 컨트롤러
  final emailController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  // 상태 변수
  RxBool isConfirmHidden = true.obs;
  RxInt currentStep = 0.obs; // 0: 이메일 입력, 1: 비번 변경
  RxBool isLoading = false.obs;

  // 에러 메시지
  RxString emailError = ''.obs;

  // ✅ 실제 서버 주소
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  @override
  void onInit() {
    super.onInit();
    // 입력 시 에러 초기화
    emailController.addListener(() {
      if (emailError.isNotEmpty) emailError.value = '';
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }

  void toggleConfirmVisibility() => isConfirmHidden.value = !isConfirmHidden.value;

  // 🚀 1단계: 비밀번호 재설정 요청 (이메일 확인)
  Future<void> requestPasswordReset() async {
    String email = emailController.text;

    if (!GetUtils.isEmail(email)) {
      emailError.value = "이메일 형식이 올바르지 않습니다.";
      return;
    }

    isLoading.value = true;
    try {
      // API 호출: POST /auth/password-reset/request
      final url = Uri.parse('$baseUrl/auth/password-reset/request');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        print("✅ 요청 성공: ${response.body}");
        // 성공하면 다음 단계(비번 변경창)로 이동
        currentStep.value = 1;
      } else {
        print("❌ 요청 실패: ${response.body}");
        // 실패하면 가입되지 않은 이메일로 간주
        emailError.value = "가입되지 않은 이메일입니다.";
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // 🚀 2단계: 비밀번호 진짜 변경 (Confirm)
  Future<void> confirmPasswordReset() async {
    if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
      Get.snackbar("알림", "비밀번호를 모두 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 비밀번호 일치 확인
    if (newPassController.text != confirmPassController.text) {
      Get.snackbar(
          "오류", "비밀번호를 다시 확인해주세요.",
          backgroundColor: const Color(0xFFEA1717), colorText: Colors.white, snackPosition: SnackPosition.BOTTOM
      );
      return;
    }

    isLoading.value = true;
    try {
      // API 호출: POST /auth/password-reset/confirm
      final url = Uri.parse('$baseUrl/auth/password-reset/confirm');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text, // 1단계 이메일 재사용
          "new_password": newPassController.text
        }),
      );

      if (response.statusCode == 200) {
        print("✅ 변경 성공: ${response.body}");
        Get.snackbar(
            "성공", "비밀번호가 변경되었습니다.",
            backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2)
        );

        // 1.5초 뒤 로그인 화면으로 이동
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.offAllNamed(Routes.login);
        });
      } else {
        print("❌ 변경 실패: ${response.body}");
        Get.snackbar("실패", "비밀번호 변경에 실패했습니다.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}