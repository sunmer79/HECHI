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
        // 1. 독서 권수 (볼드체 제거)
        Obx(() => Text(
          "${controller.totalReadCount.value}권 독서",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500, // ✅ 볼드 제거
              color: Color(0xFF3F3F3F)
          ),
        )),
        const SizedBox(height: 8),

        // 2. 장르 요약 or 독려 멘트 (색상 톤 다운)
        Obx(() {
          // [Case 1] 읽은 책이 0권일 때
          if (controller.totalReadCount.value == 0) {
            return const Text(
              "독서의 즐거움을 발견해보세요! 📚",
              style: TextStyle(fontSize: 14, color: Colors.black54), // ✅ 색상 연하게 (black54)
            );
          }

          // [Case 2] 읽은 책은 있는데 장르 정보가 없을 때
          if (controller.topGenre.value.isEmpty || controller.topGenre.value == "-") {
            return Text(
              "${controller.currentMonth.value}월의 독서 기록이 쌓이고 있어요.",
              style: const TextStyle(fontSize: 14, color: Colors.black54), // ✅ 색상 연하게
            );
          }

          // [Case 3] 정상적으로 장르가 있을 때
          return RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black54), // ✅ 기본 텍스트 색상 연하게
              children: [
                TextSpan(text: "${controller.currentMonth.value}월엔 "),
                TextSpan(
                  text: controller.topGenre.value,
                  style: const TextStyle(
                    color: Color(0xFF4DB56C), // 강조 색상은 유지
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const TextSpan(text: " 관련 책을 가장 많이 즐겼어요."),
              ],
            ),
          );
        }),
      ],
    );
  }
}