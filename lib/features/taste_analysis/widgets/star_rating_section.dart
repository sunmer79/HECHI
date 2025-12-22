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
              "별점분포",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3F3F3F)
              )
          ),
          const SizedBox(height: 5),

          Obx(() => StarRatingChart(
              ratingData: controller.starRatingDistribution,
              mostGivenRating: controller.mostGivenRating.value
          )),

          const SizedBox(height: 30),

          // ✅ [수정됨] 통계 사이에 회색 구분선 추가
          Obx(() => Row(
            children: [
              // 1. 별점 평균
              Expanded(
                child: _buildBottomStatItem(controller.averageRating.value, "별점 평균"),
              ),

              // 1번과 2번 사이 구분선
              Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),

              // 2. 별점 개수
              Expanded(
                child: _buildBottomStatItem(controller.totalReviews.value, "별점 개수"),
              ),

              // 2번과 3번 사이 구분선
              Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),

              // 3. 많이 준 별점
              Expanded(
                child: _buildBottomStatItem(controller.mostGivenRating.value, "많이 준 별점"),
              ),
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