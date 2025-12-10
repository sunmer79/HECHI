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
          Expanded(child: _buildStatItem(controller.activityStats['evaluations'] ?? 0, "평가")),
          Container(width: 1, height: 24, color: const Color(0xFFEEEEEE)),
          Expanded(child: _buildStatItem(controller.activityStats['comments'] ?? 0, "코멘트")),
        ],
      ),
    ));
  }

  Widget _buildStatItem(int count, String label) {
    return Column(
      children: [
        Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}