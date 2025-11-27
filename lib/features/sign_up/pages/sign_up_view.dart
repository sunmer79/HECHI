import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up_controller.dart';
import '../widgets/sign_up_text_field.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 1. 로고
              const Text(
                'HECHI',
                style: TextStyle(
                  color: Color(0xFF4DB56C),
                  fontSize: 48,
                  fontFamily: 'Gaegu',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 50),

              // 2. 입력 폼
              Column(
                children: [
                  // 이름 (항상 별표 보임)
                  SignUpTextField(
                    label: '이름',
                    hintText: '이름을 입력해주세요.',
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),

                  // 닉네임 (항상 별표 보임)
                  SignUpTextField(
                    label: '닉네임',
                    hintText: '2글자 이상(한글, 영문, 숫자 조합)',
                    controller: controller.nicknameController,
                  ),
                  const SizedBox(height: 20),

                  // 이메일 (항상 별표 보임)
                  Obx(() => SignUpTextField(
                    label: '이메일(아이디)',
                    hintText: '올바른 이메일을 입력해주세요.',
                    controller: controller.emailController,
                    // showAsterisk 삭제 -> 기본값 true 적용
                    suffix: GestureDetector(
                      onTap: controller.checkEmailDuplicate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: controller.isEmailFilled.value
                              ? const Color(0xFF4DB56C)
                              : const Color(0xFFC4E1CD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '중복 확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),

                  // 이메일 상태 메시지
                  Obx(() {
                    if (controller.isEmailAvailable.value == null) return const SizedBox.shrink();
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        controller.emailStatusMessage.value,
                        style: TextStyle(
                          color: controller.isEmailAvailable.value!
                              ? const Color(0xFF4DB56C)
                              : const Color(0xFFEA1717),
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // 비밀번호 (항상 별표 보임)
                  Obx(() => SignUpTextField(
                    label: '비밀번호',
                    hintText: '영문, 숫자, 특수문자 조합(8자~20자)',
                    controller: controller.passwordController,
                    isObscure: controller.isPasswordHidden.value,
                    // showAsterisk 삭제 -> 기본값 true 적용
                    suffix: GestureDetector(
                      onTap: controller.togglePasswordVisibility,
                      child: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF717171),
                      ),
                    ),
                  )),
                ],
              ),

              const SizedBox(height: 60),

              // 3. 가입하기 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.submitSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB56C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '가입하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}