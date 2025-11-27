import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  // 텍스트 필드 컨트롤러
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 상태 변수 (글자가 채워졌는지 확인하는 스위치들)
  RxBool isNameFilled = false.obs;
  RxBool isNicknameFilled = false.obs;
  RxBool isEmailFilled = false.obs;
  RxBool isPasswordFilled = false.obs;

  RxBool isPasswordHidden = true.obs;
  Rxn<bool> isEmailAvailable = Rxn<bool>();
  RxString emailStatusMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 1. 이름 입력 감지
    nameController.addListener(() {
      isNameFilled.value = nameController.text.isNotEmpty;
    });

    // 2. 닉네임 입력 감지
    nicknameController.addListener(() {
      isNicknameFilled.value = nicknameController.text.isNotEmpty;
    });

    // 3. 이메일 입력 감지
    emailController.addListener(() {
      isEmailFilled.value = emailController.text.isNotEmpty;
      if (isEmailAvailable.value != null) {
        isEmailAvailable.value = null;
        emailStatusMessage.value = '';
      }
    });

    // 4. 비밀번호 입력 감지
    passwordController.addListener(() {
      isPasswordFilled.value = passwordController.text.isNotEmpty;
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

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void checkEmailDuplicate() {
    if (!isEmailFilled.value) return;

    String inputEmail = emailController.text;
    bool isValidFormat = GetUtils.isEmail(inputEmail);

    if (!isValidFormat) {
      isEmailAvailable.value = false;
      emailStatusMessage.value = '이메일 형식이 올바르지 않습니다.';
      return;
    }

    if (inputEmail.contains('fail')) {
      isEmailAvailable.value = false;
      emailStatusMessage.value = '이미 가입된 이메일입니다.';
    } else {
      isEmailAvailable.value = true;
      emailStatusMessage.value = '사용 가능한 이메일입니다.';
    }
  }

  void submitSignUp() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("알림", "모든 정보를 입력해주세요.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar(
      "가입을 축하합니다!",
      "HECHI의 회원이 되셨습니다.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home');
    });
  }
}