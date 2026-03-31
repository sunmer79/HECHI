import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/email_verify_controller.dart';
import '../widgets/verify_header.dart';
import '../widgets/verify_input.dart';
import '../widgets/verify_submit_button.dart';
import '../widgets/verify_resend_button.dart';

class EmailVerifyView extends GetView<EmailVerifyController> {
  const EmailVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('이메일 인증', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VerifyHeader(targetEmail: controller.targetEmail),
            const SizedBox(height: 40),

            VerifyInput(controller: controller.codeController),
            const SizedBox(height: 24),

            Obx(() => VerifySubmitButton(
              isLoading: controller.isLoading.value,
              onPressed: controller.verifyEmail,
            )),
            const SizedBox(height: 16),

            VerifyResendButton(onPressed: controller.resendCode),
          ],
        ),
      ),
    );
  }
}