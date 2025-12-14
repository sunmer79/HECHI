import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';

class ActivityStats extends StatelessWidget {
  final MyReadController controller;

  const ActivityStats({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // ✅ 수정 1: Map 대신 totalReviews 변수 직접 사용
          Expanded(child: _buildStatItem(controller.totalReviews.value, "평가")),

          Container(width: 1, height: 24, color: const Color(0xFFEEEEEE)),

          // ✅ 수정 2: Map 대신 totalComments 변수 직접 사용 (여기가 핵심!)
          Expanded(child: _buildStatItem(controller.totalComments.value, "코멘트")),
        ],
      ),
    ));
  }

  // ✅ 수정 3: 매개변수 타입을 int -> String으로 변경
  // (Controller에서 String으로 관리하기 때문)
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
            count,
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
                fontSize: 12,
                color: Colors.grey
            )
        ),
      ],
    );
  }
}