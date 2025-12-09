import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';
import '../../../../core/widgets/bottom_bar.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left, color: Colors.black54),
              onPressed: () => controller.changeMonth(-1),
            ),
            Obx(() => Text(
              "${controller.currentYear.value}년 ${controller.currentMonth.value}월",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            )),
            IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.black54),
              onPressed: () => controller.changeMonth(1),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 1. 월간 요약 섹션
                Text(
                  "${controller.totalReadCount.value}권 독서",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F3F3F)
                  ),
                ),
                const SizedBox(height: 8),

                if (controller.topGenre.value.isNotEmpty)
                  RichText(
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
                  )
                else
                  const Text(
                    "이번 달은 어떤 책을 읽으셨나요?",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),


                const SizedBox(height: 50),

                // 2. 요일 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F3F3F)
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // ✅ [수정] 간격 축소 (10 -> 6)
                const SizedBox(height: 12),

                // 3. 달력 그리드
                _buildCalendarGrid(),

                const SizedBox(height: 40), // 하단 여백 유지
              ],
            ),
          ),
        );
      }),
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
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        // ✅ [수정] 비율 조정 (0.65 -> 0.7) : 세로 길이를 줄여서 여백 감소 효과
        childAspectRatio: 0.65,
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
              const Spacer(),


            const SizedBox(height: 6),

            if (!hasBook)
              Text(
                  "$day",
                  style: const TextStyle(fontSize: 12, color: Colors.black54)
              ),
          ],
        );
      },
    );
  }
}