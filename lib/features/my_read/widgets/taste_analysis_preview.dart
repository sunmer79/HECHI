import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';
import '../../taste_analysis/widgets/star_rating_chart.dart';

class TasteAnalysisPreview extends StatelessWidget {
  final MyReadController controller;

  const TasteAnalysisPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // ✅ 공통 위젯 사용!
            StarRatingChart(
              ratingData: controller.ratingDistData,
              mostGivenRating: controller.mostGivenRating.value,
            ),

            const SizedBox(height: 30),

            // 하단 통계 (기존 유지)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomStatItem(controller.averageRating.value, "별점 평균"),
                Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),
                _buildBottomStatItem(controller.totalReviews.value, "별점 개수"),
                Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),
                _buildBottomStatItem(controller.mostGivenRating.value, "많이 준 별점"),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}