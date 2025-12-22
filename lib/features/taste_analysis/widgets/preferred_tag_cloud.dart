import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class PreferredTagCloud extends GetView<TasteAnalysisController> {
  const PreferredTagCloud({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("독서 선호 태그", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.totalReviews.value == "0" || controller.tags.isEmpty) {
              return const Center(child: Text("아직 분석된 태그가 없습니다.", style: TextStyle(color: Colors.grey)));
            }

            const double stackHeight = 160;

            // ✅ LayoutBuilder를 사용하여 화면 너비에 맞춰 태그 위치 자동 조정
            return SizedBox(
              height: stackHeight,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: controller.tags.map((tag) {
                      double size = (tag['size'] as num).toDouble();
                      Color color = Color(tag['color'] as int);
                      Offset position = tag['position'] as Offset;

                      // constraints.maxWidth를 곱해 화면 너비에 비례하게 배치
                      return Positioned(
                        left: position.dx * constraints.maxWidth * 0.9, // 0.9는 여백 확보용
                        top: position.dy * stackHeight,
                        child: Text(
                          tag['text'] as String,
                          style: TextStyle(fontSize: size * 1.3, color: color, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}