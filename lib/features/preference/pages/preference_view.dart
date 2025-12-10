import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';

// 분리한 위젯들 임포트
import '../widgets/preference_intro_step.dart';
import '../widgets/preference_category_step.dart';
import '../widgets/preference_genre_step.dart';

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
            return PreferenceCategoryStep(controller: controller);
          case 2:
            return PreferenceGenreStep(controller: controller);
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}