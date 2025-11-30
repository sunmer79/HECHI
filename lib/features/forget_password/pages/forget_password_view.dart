import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forget_password_controller.dart';
import '../../sign_up/widgets/sign_up_text_field.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '비밀번호 재설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // 현재 단계에 따라 화면 교체
          if (controller.currentStep.value == 0) {
            return _buildStep1EmailCheck();
          } else {
            return _buildStep2ResetPassword();
          }
        }),
      ),
    );
  }

  // 1단계: 이메일 입력 화면
  Widget _buildStep1EmailCheck() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: const Color(0xFFABABAB),
            child: const Text('기존에 가입한 이메일(아이디)을 입력해주세요.', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SignUpTextField(
                  label: '이메일',
                  hintText: '가입하신 이메일(아이디)을 작성해주세요.',
                  controller: controller.emailController,
                ),

                // 에러 메시지
                Obx(() => controller.emailError.isEmpty
                    ? const SizedBox(height: 20)
                    : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 5, bottom: 15, left: 5),
                  child: Text(controller.emailError.value, style: const TextStyle(color: Color(0xFFEA1717), fontSize: 13)),
                )
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.requestPasswordReset,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DB56C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('이메일(아이디) 확인하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2단계: 비밀번호 변경 화면
  Widget _buildStep2ResetPassword() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: const Color(0xFFABABAB),
            child: const Text('새 비밀번호를 작성해주세요.', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 새 비밀번호 (보임)
                SignUpTextField(
                  label: '새 비밀번호',
                  hintText: '영문, 숫자, 특수문자 조합(8자~20자)',
                  controller: controller.newPassController,
                  isObscure: false,
                ),
                const SizedBox(height: 20),

                // 비밀번호 확인 (숨김 + 눈 아이콘)
                Obx(() => SignUpTextField(
                  label: '비밀번호 확인',
                  hintText: '비밀번호를 한번 더 입력해주세요.',
                  controller: controller.confirmPassController,
                  isObscure: controller.isConfirmHidden.value,
                  suffix: GestureDetector(
                    onTap: controller.toggleConfirmVisibility,
                    child: Icon(controller.isConfirmHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF717171)),
                  ),
                )),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.confirmPasswordReset,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DB56C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('비밀번호 변경하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}