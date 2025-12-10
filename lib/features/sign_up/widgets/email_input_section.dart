import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up_controller.dart';
import 'sign_up_text_field.dart'; // 기존에 만드신 파일 import

class EmailInputSection extends StatelessWidget {
  final SignUpController controller;

  const EmailInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 이메일 입력창 & 중복확인 버튼
        Obx(() => SignUpTextField(
          label: '이메일(아이디)',
          hintText: '예) hechi@kmu.ac.kr',
          controller: controller.emailController,
          suffix: Transform.translate(
            offset: const Offset(20, 0),
            child: GestureDetector(
              onTap: controller.checkEmailDuplicate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  // 이메일이 입력되었을 때만 진한 색
                  color: controller.isEmailFilled.value
                      ? const Color(0xFF4DB56C)
                      : const Color(0xFFC4E1CD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
        )),

        // 2. 상태 메시지 (사용 가능 / 중복된 이메일 등)
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
      ],
    );
  }
}