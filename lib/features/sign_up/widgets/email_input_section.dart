import 'package:flutter/material.dart';
import '../controllers/sign_up_controller.dart';
import 'sign_up_text_field.dart';

class EmailInputSection extends StatelessWidget {
  final SignUpController controller;

  const EmailInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // 중복확인 버튼은 아이디(login_id) 쪽으로 이동했고, 여기는 단순 이메일 입력만 받습니다.
    return SignUpTextField(
      label: '이메일',
      hintText: '예) hechi@kmu.ac.kr',
      controller: controller.emailController,
    );
  }
}