import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

// 분리한 위젯들 임포트
import '../widgets/login_logo.dart';
import '../widgets/login_text_field.dart';
import '../widgets/auto_login_checkbox.dart';
import '../widgets/login_button.dart';
import '../widgets/login_bottom_links.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // 1. 로고
                  const LoginLogo(),
                  const SizedBox(height: 60),

                  // 2. 이메일 입력 (에러 메시지 반응형 처리를 위해 Obx로 감싸기)
                  Obx(() => LoginTextField(
                    label: '이메일(아이디)',
                    controller: controller.emailController,
                    hintText: "이메일을 입력해주세요",
                    keyboardType: TextInputType.emailAddress,
                    errorText: controller.emailError.value, // RxString의 값 전달
                  )),
                  const SizedBox(height: 20),

                  // 3. 비밀번호 입력 (비밀번호 숨김/표시 상태 반응형 처리)
                  Obx(() => LoginTextField(
                    label: '비밀번호',
                    controller: controller.passwordController,
                    hintText: "비밀번호를 입력해주세요",
                    isPassword: true, // 눈 아이콘 표시용
                    obscureText: controller.isPasswordHidden.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                    errorText: controller.passwordError.value,
                  )),
                  const SizedBox(height: 12),

                  // 4. 자동 로그인 체크박스
                  Obx(() => AutoLoginCheckbox(
                    isChecked: controller.isAutoLogin.value,
                    onTap: controller.toggleAutoLogin,
                  )),
                  const SizedBox(height: 30),

                  // 5. 로그인 버튼
                  Obx(() => LoginButton(
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.login(),
                  )),
                  const SizedBox(height: 24),

                  // 6. 하단 링크 (회원가입/비번찾기)
                  LoginBottomLinks(
                    onSignUp: controller.goToSignUp,
                    onFindPassword: controller.goToForgetPassword,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}