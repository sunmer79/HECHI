import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class ReadingTimeSection extends GetView<TasteAnalysisController> {
  const ReadingTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("독서 감상 시간", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Center(
            child: Obx(() => RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  const TextSpan(text: "총 "),
                  TextSpan(
                    // ✅ 시간 값 (공백 없이 입력)
                      text: controller.totalReadingTime.value,
                      style: const TextStyle(color: Color(0xFF4DB56C), fontWeight: FontWeight.bold)
                  ),
                  // ✅ " 동안"으로 시작하여 띄어쓰기 확보
                  const TextSpan(text: " 동안 감상하셨습니다."),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}