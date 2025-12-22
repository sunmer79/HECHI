import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class MonthlySummarySection extends StatelessWidget {
  final CalendarController controller;

  const MonthlySummarySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const TextStyle commonStyle = TextStyle(
      fontSize: 13,
      color: Colors.black54,
      height: 1.4,
      letterSpacing: -0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          "${controller.totalReadCount.value}권 독서",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3F3F3F)
          ),
        )),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.totalReadCount.value == 0) {
            return const Text(
              "독서의 즐거움을 발견해보세요! 📚",
              style: commonStyle,
            );
          }

          if (controller.topGenre.value.isEmpty || controller.topGenre.value == "-") {
            return Text(
              "${controller.currentMonth.value}월의 독서 기록이 쌓이고 있어요.",
              style: commonStyle,
            );
          }

          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "${controller.currentMonth.value}월엔 "),
                TextSpan(
                  text: controller.topGenre.value,
                  style: const TextStyle(
                    color: Color(0xFF4DB56C),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const TextSpan(text: " 관련 책을 가장 많이 즐겼어요."),
              ],
            ),
            style: commonStyle,
          );
        }),
      ],
    );
  }
}