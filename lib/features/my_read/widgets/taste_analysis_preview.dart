import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';

class TasteAnalysisPreview extends StatelessWidget {
  final MyReadController controller;

  const TasteAnalysisPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.ratingDistData.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text("아직 취향 분석 데이터가 충분하지 않습니다.", style: TextStyle(color: Colors.grey)),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // #별점분포 태그
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF81C784),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text("#별점분포",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),

            // 1. 별점 그래프
            Column(
              children: controller.ratingDistData.map((d) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text("${d['score']}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: LinearProgressIndicator(
                            value: (d['ratio'] as num).toDouble(),
                            backgroundColor: const Color(0xFFF5F5F5),
                            color: Color(d['color'] as int),
                            minHeight: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // 2. 하단 통계
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomStatItem(controller.averageRating.value, "별점 평균"),
                _buildBottomStatItem(controller.totalReviews.value, "별점 개수"),
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
        Text(
            value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500, // Medium
                color: Color(0xFF3F3F3F)
            )
        ),
        const SizedBox(height: 4),
        Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey)
        ),
      ],
    );
  }
}