import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  // --- Step 1: 이메일 확인 ---
  final emailController = TextEditingController();
  RxBool isEmailFilled = false.obs;
  RxString emailError = ''.obs;

  // --- Step 2: 비밀번호 재설정 ---
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  RxBool isNewPassFilled = false.obs;
  RxBool isConfirmPassFilled = false.obs;

  // 비밀번호 확인란만 눈 모양 기능
  RxBool isConfirmHidden = true.obs;

  // 현재 단계 (0: 이메일 확인, 1: 재설정)
  RxInt currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // 리스너: 입력할 때마다 상태 업데이트 및 에러 초기화
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

  // [1단계] 이메일 존재 확인
  void checkEmailAndMoveStep() {
    String email = emailController.text;

    if (email == "HECHI@kmu.ac.kr") {
      // 성공 -> 2단계로 화면 전환
      currentStep.value = 1;
    } else {
      // 실패 -> 에러 메시지
      emailError.value = "가입되지 않은 이메일입니다.";
    }
  }

  // [2단계] 비밀번호 재설정 완료
  void resetPassword() {
    // 1. 빈칸 체크
    if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
      Get.snackbar(
        "알림",
        "비밀번호를 모두 입력해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black54,
        colorText: Colors.white,
      );
      return;
    }

    // 2. 비밀번호 불일치 체크
    if (newPassController.text != confirmPassController.text) {
      Get.snackbar(
        "오류",
        "비밀번호를 다시 확인해주세요.",
        backgroundColor: const Color(0xFFEA1717), // 빨간색 배경
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 3. 비밀번호 일치 - 성공 메시지 및 이동
    Get.snackbar(
      "성공",
      "비밀번호가 변경되었습니다.",
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2), // 메시지 표시 시간
    );

    // 1.5초 뒤에 로그인 화면으로 자동 이동
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.offAllNamed('/login');
    });
  }
}