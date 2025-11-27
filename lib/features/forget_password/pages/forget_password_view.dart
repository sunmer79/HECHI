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
          // 단계에 따라 다른 위젯 보여주기
          if (controller.currentStep.value == 0) {
            return _buildStep1EmailCheck();
          } else {
            return _buildStep2ResetPassword();
          }
        }),
      ),
    );
  }

  // --- [1단계] 이메일 확인 화면 ---
  Widget _buildStep1EmailCheck() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: const Color(0xFFABABAB),
            child: const Text(
              '기존에 가입한 이메일(아이디)을 입력해주세요.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 이메일 입력 (항상 별표 보임)
                SignUpTextField(
                  label: '이메일',
                  hintText: '가입하신 이메일(아이디)을 작성해주세요.',
                  controller: controller.emailController,
                  // showAsterisk 생략 -> 기본값 true
                ),

                // 에러 메시지 (이메일 칸 아래)
                Obx(() {
                  if (controller.emailError.isEmpty) return const SizedBox(height: 20);
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5, bottom: 15, left: 5),
                    child: Text(
                      controller.emailError.value,
                      style: const TextStyle(color: Color(0xFFEA1717), fontSize: 13),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.checkEmailAndMoveStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB56C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('이메일(아이디) 확인하기', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- [2단계] 비밀번호 재설정 화면 ---
  Widget _buildStep2ResetPassword() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: const Color(0xFFABABAB),
            child: const Text(
              '새 비밀번호를 작성해주세요.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 새 비밀번호 (그냥 보임, 점 없음)
                SignUpTextField(
                  label: '새 비밀번호',
                  hintText: '영문, 숫자, 특수문자 조합(8자~20자)',
                  controller: controller.newPassController,
                  isObscure: false, // 안 가림
                ),

                const SizedBox(height: 20),

                // 비밀번호 확인 (가려짐 + 눈 아이콘)
                Obx(() => SignUpTextField(
                  label: '비밀번호 확인',
                  hintText: '비밀번호를 한번 더 입력해주세요.',
                  controller: controller.confirmPassController,
                  isObscure: controller.isConfirmHidden.value,
                  suffix: GestureDetector(
                    onTap: controller.toggleConfirmVisibility,
                    child: Icon(
                      controller.isConfirmHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF717171),
                    ),
                  ),
                )),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB56C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('비밀번호 변경하기', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}