import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class MonthlySummarySection extends StatelessWidget {
  final CalendarController controller;

  const MonthlySummarySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 독서 권수
        Obx(() => Text(
          "${controller.totalReadCount.value}권 독서",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3F3F3F)
          ),
        )),
        const SizedBox(height: 8),

        // 2. 장르 요약 or 기본 멘트
        Obx(() {
          if (controller.topGenre.value.isNotEmpty) {
            return RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(text: "${controller.currentMonth.value}월엔 "),
                  TextSpan(
                    text: controller.topGenre.value,
                    style: const TextStyle(
                      color: Color(0xFF4DB56C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: "을 가장 많이 즐겼어요"),
                ],
              ),
            );
          } else {
            return const Text(
              "이번 달은 어떤 책을 읽으셨나요?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            );
          }
        }),
      ],
    );
  }
}