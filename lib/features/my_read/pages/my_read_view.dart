import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

import '../controllers/my_read_controller.dart';
import '../../../../core/widgets/common_calendar_widget.dart';

// ✅ 위젯 임포트
import '../widgets/profile_header.dart';
import '../widgets/activity_stats.dart';
import '../widgets/section_title.dart';
import '../widgets/taste_analysis_preview.dart';
import '../widgets/see_all_button.dart';
import '../widgets/book_storage_link.dart';

class MyReadView extends GetView<MyReadController> {
  const MyReadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF4DB56C),
        onRefresh: () async => await controller.fetchMyReadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 프로필
              ProfileHeader(controller: controller),
              const SizedBox(height: 20),

              // 2. 활동 통계
              ActivityStats(controller: controller),
              const SizedBox(height: 20),

              // ✅ [복구] 평가/코멘트 밑 -> 두꺼운 선으로 변경
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 3. 보관함 링크
              const BookStorageLink(),

              // (참고) 보관함과 캘린더 사이는 얇은 선 유지 (요청하신 부분만 변경)
              const Divider(color: Color(0xFFF5F5F5), thickness: 1, height: 1),

              // 4. 캘린더 섹션
              const SizedBox(height: 30),
              _buildCalendarHeader(),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(() => CommonCalendarWidget(
                  currentYear: controller.currentYear.value,
                  currentMonth: controller.currentMonth.value,
                  bookCovers: controller.calendarBooks,
                  dailyBooks: controller.dailyBooks,
                )),
              ),

              const SizedBox(height: 20),
              _buildCalendarFooter(),

              const SizedBox(height: 20),

              // ✅ [복구] 캘린더 밑 -> 두꺼운 선으로 변경
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 5. 취향 분석
              const SectionTitle(title: "취향 분석"),
              TasteAnalysisPreview(controller: controller),

              const SizedBox(height: 20),
              // 6. 전체 보기 버튼
              const SeeAllTasteButton(),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // 캘린더 헤더
  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
            onPressed: () => controller.changeMonth(-1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 20),
          Text(
            '${controller.currentMonth.value}월 캘린더',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            onPressed: () => controller.changeMonth(1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      )),
    );
  }

  // 캘린더 푸터 (전체보기)
  Widget _buildCalendarFooter() {
    return Center(
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.calendar),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("캘린더 전체 보기", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}