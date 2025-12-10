import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import '../controllers/my_read_controller.dart';

class MiniCalendarSection extends StatelessWidget {
  final MyReadController controller;

  const MiniCalendarSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          // 1. 헤더 (월 이동)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, color: Colors.black54),
                onPressed: () => controller.changeMonth(-1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Obx(() => Text(
                  "${controller.currentMonth.value}월 캘린더 (${controller.monthlyReadCount.value}권)",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))
              )),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_right, color: Colors.black54),
                onPressed: () => controller.changeMonth(1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. 요일
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) {
              return Expanded(
                child: Center(
                  child: Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // 3. 그리드
          Obx(() => _buildCalendarGrid()),

          const SizedBox(height: 40),

          // 4. 전체보기 링크
          InkWell(
            onTap: () => Get.toNamed(Routes.calendar),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("캘린더 전체 보기", style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
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
          crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.7),
      itemCount: startOffset + totalDays,
      itemBuilder: (context, index) {
        if (index < startOffset) return const SizedBox();
        final day = index - startOffset + 1;
        final hasBook = controller.calendarBooks.containsKey(day);
        final bookImageUrl = controller.calendarBooks[day];

        return Column(
          children: [
            if (hasBook && bookImageUrl != null && bookImageUrl.isNotEmpty)
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(bookImageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]))))
            else
              const Spacer(),
            const SizedBox(height: 4),
            if (!hasBook) Text("$day", style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        );
      },
    );
  }
}