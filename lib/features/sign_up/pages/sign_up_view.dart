import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up_controller.dart';

import '../widgets/sign_up_logo.dart';
import '../widgets/sign_up_text_field.dart';
// ✅ 아이디 입력 위젯 임포트 추가
import '../widgets/login_id_input_section.dart';
import '../widgets/email_input_section.dart';
import '../widgets/password_input_section.dart';
import '../widgets/sign_up_button.dart';

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
              const SignUpLogo(),
              const SizedBox(height: 50),

              // 2. 이름 입력
              SignUpTextField(
                  label: '이름',
                  hintText: '이름을 입력해주세요.',
                  controller: controller.nameController
              ),
              const SizedBox(height: 20),

              // 3. 닉네임 입력
              SignUpTextField(
                  label: '닉네임',
                  hintText: '2글자 이상(한글, 영문, 숫자 조합)',
                  controller: controller.nicknameController
              ),
              const SizedBox(height: 20),

              // ✅ 4. 아이디 입력 섹션 (새로 추가됨)
              LoginIdInputSection(controller: controller),
              const SizedBox(height: 20),

              // 5. 이메일 섹션 (이제 단순 입력창 역할만 함)
              EmailInputSection(controller: controller),
              const SizedBox(height: 20),

              // 6. 비밀번호 섹션
              PasswordInputSection(controller: controller),
              const SizedBox(height: 60),

              // 7. 가입하기 버튼
              SignUpButton(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}