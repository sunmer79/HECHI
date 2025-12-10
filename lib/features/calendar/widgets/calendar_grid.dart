import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarGrid extends StatelessWidget {
  final CalendarController controller;

  const CalendarGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // 날짜 계산 로직을 위해 Obx 안에서 값을 가져옴
    return Obx(() {
      final year = controller.currentYear.value;
      final month = controller.currentMonth.value;

      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);

      final startOffset = firstDay.weekday - 1;
      final totalDays = lastDay.day;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65, // 비율 조정
        ),
        itemCount: startOffset + totalDays,
        itemBuilder: (context, index) {
          if (index < startOffset) {
            return const SizedBox();
          }

          final day = index - startOffset + 1;
          final hasBook = controller.calendarBooks.containsKey(day);
          final bookImageUrl = controller.calendarBooks[day];

          return Column(
            children: [
              // 책 표지 영역
              if (hasBook && bookImageUrl != null && bookImageUrl.isNotEmpty)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        bookImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(), // 책이 없으면 빈 공간 채우기

              const SizedBox(height: 6),

              // 날짜 텍스트 (책이 없을 때만 표시)
              if (!hasBook)
                Text(
                  "$day",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
            ],
          );
        },
      );
    });
  }
}