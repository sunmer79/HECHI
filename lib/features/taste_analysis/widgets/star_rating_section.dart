import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';
import 'star_rating_chart.dart';

class StarRatingSection extends GetView<TasteAnalysisController> {
  const StarRatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              "별점 분포",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F)
              )
          ),
          const SizedBox(height: 10),

          Obx(() => StarRatingChart(
              ratingData: controller.starRatingDistribution,
              mostGivenRating: controller.mostGivenRating.value
          )),

          const SizedBox(height: 30),

          Obx(() => Row(
            children: [
              Expanded(child: _buildBottomStatItem(controller.averageRating.value, "별점 평균")),
              Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),
              Expanded(child: _buildBottomStatItem(controller.totalReviews.value, "별점 개수")),
              Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),
              Expanded(child: _buildBottomStatItem(controller.mostGivenRating.value, "많이 준 별점")),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildBottomStatItem(String value, String label) {
    return Column(
      children: [
        Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F3F3F)
            )
        ),
        const SizedBox(height: 4),
        Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey
            )
        ),
      ],
    );
  }
}