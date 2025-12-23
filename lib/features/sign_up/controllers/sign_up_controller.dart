import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hechi/app/routes.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isEmailFilled = false.obs;

  // true: 사용가능, false: 중복/불가, null: 확인 안 함
  Rxn<bool> isEmailAvailable = Rxn<bool>();
  RxString emailStatusMessage = ''.obs;
  RxBool isLoading = false.obs;

  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      isEmailFilled.value = emailController.text.isNotEmpty;
      // 이메일 내용이 바뀌면 중복 확인 상태 초기화 (다시 확인 필요)
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

  Future<void> checkEmailDuplicate() async {
    if (!isEmailFilled.value) return;

    if (!GetUtils.isEmail(emailController.text)) {
      isEmailAvailable.value = false;
      emailStatusMessage.value = '이메일 형식이 올바르지 않습니다.';
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/auth/email-check?email=${emailController.text}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if(data['available'] == true) {
          isEmailAvailable.value = true;
          emailStatusMessage.value = '사용 가능한 이메일입니다.';
        } else {
          isEmailAvailable.value = false;
          emailStatusMessage.value = '이미 가입된 이메일입니다.';
        }
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> submitSignUp() async {
    // 1. 기본 필드 입력 확인
    if (nameController.text.isEmpty ||
        nicknameController.text.isEmpty ||
        !isEmailFilled.value ||
        passwordController.text.isEmpty) {
      Get.snackbar("알림", "모든 필드를 입력해주세요.",
          backgroundColor: Colors.black87, colorText: Colors.white);
      return;
    }

    // ✅ [핵심 수정 부분] 이메일 중복 확인 여부 검사
    // 중복 확인을 안 했거나(null), 중복된 이메일(false)이면 가입 막음
    if (isEmailAvailable.value != true) {
      Get.snackbar("알림", "이메일 중복 확인을 먼저 완료해주세요.",
          backgroundColor: Colors.black87, colorText: Colors.white);
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
                        '회원가입 성공!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F3F3F),
                            fontFamily: 'Roboto'
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '환영합니다. 로그인을 진행해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF3F3F3F), fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Get.back(); // 팝업 닫기
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
        Get.snackbar("가입 실패", "입력 정보를 확인해주세요. (${response.statusCode})",
            backgroundColor: Colors.black87, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("오류", "서버 연결 실패",
          backgroundColor: Colors.black87, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}