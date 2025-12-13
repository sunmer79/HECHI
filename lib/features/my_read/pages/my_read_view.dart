import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

// ✅ 컨트롤러 임포트
import '../controllers/my_read_controller.dart';

// ✅ 공통 캘린더 위젯 임포트 (경로 확인 필요)
import '../../../../core/widgets/common_calendar_widget.dart';

// ✅ 분리한 위젯들 임포트
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

      // 본문 (새로고침 기능 포함)
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
              // 1. 프로필 섹션
              ProfileHeader(controller: controller),
              const SizedBox(height: 20),

              // 2. 활동 통계 섹션 (코멘트 개수 표시되는 곳)
              ActivityStats(controller: controller),
              const SizedBox(height: 20),

              // 구분선
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 3. 캘린더 섹션
              const SizedBox(height: 30),

              // 캘린더 헤더 ( < 12월 캘린더 > )
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                      onPressed: () => controller.changeMonth(-1), // 이전 달
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
                      onPressed: () => controller.changeMonth(1), // 다음 달
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )),
              ),

              const SizedBox(height: 10),

              // 캘린더 그리드 (CommonCalendarWidget 사용)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(() => CommonCalendarWidget(
                  currentYear: controller.currentYear.value,
                  currentMonth: controller.currentMonth.value,
                  bookCovers: controller.calendarBooks,
                  dailyBooks: controller.dailyBooks, // ✅ 바텀시트 데이터 연결 완료
                )),
              ),

              const SizedBox(height: 20),

              // 4. "캘린더 전체 보기" 버튼
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

              // 구분선
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 5. 취향 분석 섹션
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