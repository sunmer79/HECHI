import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import '../controllers/my_read_controller.dart';

// ✅ 공통 캘린더 위젯 임포트 (경로는 프로젝트 상황에 맞춰주세요)
import '../../../../core/widgets/common_calendar_widget.dart';

// 분리한 위젯들 임포트 (기존 경로 유지)
import '../widgets/profile_header.dart';
import '../widgets/activity_stats.dart';
import '../widgets/section_title.dart';
import '../widgets/archive_link_button.dart';
import '../widgets/taste_analysis_preview.dart';
import '../widgets/see_all_button.dart';

class MyReadView extends GetView<MyReadController> {
  const MyReadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 상단 앱바
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

      // 본문
      body: RefreshIndicator(
        color: const Color(0xFF4DB56C),
        onRefresh: () async {
          await controller.fetchMyReadData();
        },
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

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 3. 캘린더 섹션 (헤더 + 그리드)
              const SizedBox(height: 30),

              // ✅ [직접 구현] 네비게이션 헤더 (< 12월 캘린더 >)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                      onPressed: () => controller.changeMonth(-1), // 이전 달 이동
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${controller.currentMonth.value}월 캘린더', // 현재 월 표시
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      onPressed: () => controller.changeMonth(1), // 다음 달 이동
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )),
              ),

              const SizedBox(height: 10),

              // ✅ [수정됨] 공통 위젯 사용 (dailyBooks 파라미터 추가)
              // 이제 날짜를 클릭하면 책 목록(바텀시트)이 뜹니다.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(() => CommonCalendarWidget(
                  currentYear: controller.currentYear.value,
                  currentMonth: controller.currentMonth.value,
                  bookCovers: controller.calendarBooks,
                  dailyBooks: controller.dailyBooks, // 👈 이 부분이 핵심입니다!
                )),
              ),

              const SizedBox(height: 20),

              // 4. "캘린더 전체 보기 >" 버튼
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.calendar),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "캘린더 전체 보기",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 5. 취향 분석
              const SectionTitle(title: "취향 분석"),
              TasteAnalysisPreview(controller: controller),

              const SizedBox(height: 20),

              // 6. 전체 보기 버튼
              const SeeAllTasteButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}