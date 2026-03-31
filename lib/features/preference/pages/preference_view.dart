import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';

import '../widgets/preference_intro_step.dart';
// ✅ 통합된 1단계 스텝으로 임포트 변경
import '../widgets/preference_unified_step.dart';

class PreferenceView extends GetView<PreferenceController> {
  const PreferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        switch (controller.currentStep.value) {
          case 0:
            return const PreferenceIntroStep();
          case 1:
          // ✅ 카테고리/장르를 합친 통합 뷰 호출
            return PreferenceUnifiedStep(controller: controller);
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}