import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';
import '../controllers/my_read_controller.dart';

// 분리한 위젯들 임포트
import '../widgets/profile_header.dart';
import '../widgets/activity_stats.dart';
import '../widgets/section_title.dart';
import '../widgets/archive_link_button.dart';
import '../widgets/mini_calendar_section.dart';
import '../widgets/taste_analysis_preview.dart';
import '../widgets/see_all_button.dart';

class MyReadView extends StatelessWidget {
  const MyReadView({super.key});

  @override
  Widget build(BuildContext context) {
    // 페이지 접속 시마다 컨트롤러 로직 수행
    final controller = Get.put(MyReadController());

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

              // 3. 보관함
              const SectionTitle(title: "보관함"),
              const ArchiveLinkButton(),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 4. 미니 캘린더
              MiniCalendarSection(controller: controller),

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