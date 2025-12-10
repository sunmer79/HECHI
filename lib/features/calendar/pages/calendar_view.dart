import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';
import '../../../../core/widgets/bottom_bar.dart';

// 분리한 위젯들 임포트
import '../widgets/calendar_app_bar.dart';
import '../widgets/monthly_summary_section.dart';
import '../widgets/weekday_header.dart';
import '../widgets/calendar_grid.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. 앱바 분리
      appBar: CalendarAppBar(controller: controller),

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

                // 2. 월간 요약 (몇 권, 장르)
                MonthlySummarySection(controller: controller),

                const SizedBox(height: 50),

                // 3. 요일 헤더 (Mon, Tue...)
                const WeekdayHeader(),

                const SizedBox(height: 12),

                // 4. 달력 그리드 (날짜, 책 표지)
                CalendarGrid(controller: controller),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}