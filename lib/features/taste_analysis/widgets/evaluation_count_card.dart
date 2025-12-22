import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class EvaluationCountCard extends GetView<TasteAnalysisController> {
  const EvaluationCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("평가 수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF0FDF0), Color(0xFFE8F5E9)],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Obx(() => Text(
                      controller.totalReviews.value,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF4DB56C)),
                    )),
                    const SizedBox(width: 6),
                    const Text("권", style: TextStyle(fontSize: 20, color: Color(0xFF4DB56C), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                  '지금까지 ${controller.userProfile['nickname'] ?? 'HECHI'}님이 읽고 평가한 책',
                  style: TextStyle(fontSize: 14, color: const Color(0xFF4DB56C).withValues(alpha: 0.8), fontWeight: FontWeight.w400),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}