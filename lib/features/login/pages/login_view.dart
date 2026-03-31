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
                  const LoginLogo(),
                  const SizedBox(height: 60),

                  // ✅ 이메일 -> 아이디 입력으로 변경
                  Obx(() => LoginTextField(
                    label: '아이디',
                    controller: controller.loginIdController,
                    hintText: "아이디를 입력해주세요",
                    keyboardType: TextInputType.text,
                    errorText: controller.loginIdError.value,
                  )),
                  const SizedBox(height: 20),

                  Obx(() => LoginTextField(
                    label: '비밀번호',
                    controller: controller.passwordController,
                    hintText: "비밀번호를 입력해주세요",
                    isPassword: true,
                    obscureText: controller.isPasswordHidden.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                    errorText: controller.passwordError.value,
                  )),
                  const SizedBox(height: 12),

                  Obx(() => AutoLoginCheckbox(
                    isChecked: controller.isAutoLogin.value,
                    onTap: controller.toggleAutoLogin,
                  )),
                  const SizedBox(height: 30),

                  Obx(() => LoginButton(
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.login(),
                  )),
                  const SizedBox(height: 24),

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