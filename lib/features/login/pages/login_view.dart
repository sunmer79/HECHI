import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../sign_up/widgets/sign_up_text_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // 1. 로고
              const Text(
                'HECHI',
                style: TextStyle(
                  color: Color(0xFF4DB56C),
                  fontSize: 52,
                  fontFamily: 'Gaegu',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),

              const SizedBox(height: 80),

              // 2. 이메일 입력 폼 (항상 별표 보임)
              SignUpTextField(
                label: '이메일(아이디)',
                hintText: '이메일(아이디)을 입력해주세요.',
                controller: controller.emailController,
                // showAsterisk 삭제
              ),

              // 이메일 에러 메시지
              Obx(() {
                if (controller.emailError.isEmpty) return const SizedBox(height: 20);
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5, bottom: 15, left: 5),
                  child: Text(
                    controller.emailError.value,
                    style: const TextStyle(
                      color: Color(0xFFEA1717),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),

              // 3. 비밀번호 입력 폼 (항상 별표 보임)
              Obx(() => SignUpTextField(
                label: '비밀번호',
                hintText: '영문, 숫자, 특수문자 조합(8자~20자)',
                controller: controller.passwordController,
                isObscure: controller.isPasswordHidden.value,
                // showAsterisk 삭제
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

              // 비밀번호 에러 메시지
              Obx(() {
                if (controller.passwordError.isEmpty) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Text(
                    controller.passwordError.value,
                    style: const TextStyle(
                      color: Color(0xFFEA1717),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 40),

              // 4. 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DB56C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 150),

              // 5. 하단 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.goToSignUp,
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Color(0xFF89C99C), fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.goToForgetPassword,
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(color: Color(0xFF89C99C), fontSize: 13),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}