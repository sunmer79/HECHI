import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forget_password_controller.dart';

// 분리한 위젯들 임포트
import '../widgets/forget_password_app_bar.dart';
import '../widgets/step_one_email_view.dart';
import '../widgets/step_two_reset_view.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. 분리된 앱바 사용
      appBar: const ForgetPasswordAppBar(),

      body: SafeArea(
        child: Obx(() {
          // 2. 단계에 따라 화면 위젯 교체
          if (controller.currentStep.value == 0) {
            return StepOneEmailView(controller: controller);
          } else {
            return StepTwoResetView(controller: controller);
          }
        }),
      ),
    );
  }
}