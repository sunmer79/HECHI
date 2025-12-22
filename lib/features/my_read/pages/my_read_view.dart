import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

import '../controllers/my_read_controller.dart';

import '../widgets/mini_calendar_section.dart';

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
              const Divider(color: Color(0xFFF5F5F5), thickness: 1, height: 1),


              Container(height: 1, color: const Color(0xFFF5F5F5)),

              // 3. 보관함 링크
              const BookStorageLink(),


              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // ✅ 4. 캘린더 섹션

              MiniCalendarSection(controller: controller),

              // 구분선 (두꺼운 선)
              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 5. 취향 분석
              const SizedBox(height: 20),
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