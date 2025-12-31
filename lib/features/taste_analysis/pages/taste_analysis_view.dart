import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';
import '../../../../core/widgets/bottom_bar.dart';

import '../widgets/taste_header.dart';
import '../widgets/evaluation_count_card.dart';
import '../widgets/star_rating_section.dart';
import '../widgets/reading_time_section.dart';
import '../widgets/preferred_tag_cloud.dart';
import '../widgets/preferred_genre_list.dart';

class TasteAnalysisView extends GetView<TasteAnalysisController> {
  const TasteAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB56C),
        elevation: 0,
        centerTitle: true,
        title: Obx(() => Text(
          '${controller.userProfile['nickname'] ?? 'HECHI'}님의 취향분석',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () {
                // 공유 기능 추후 구현
              }
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        }

        return RefreshIndicator(
          color: const Color(0xFF4DB56C),
          onRefresh: () async {
            await controller.fetchData();
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TasteHeader(),
                EvaluationCountCard(),
                Divider(height: 8, thickness: 8, color: Color(0xFFF5F5F5)), // 두꺼운 구분선
                StarRatingSection(),
                Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)), // 얇은 구분선
                ReadingTimeSection(),
                Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                PreferredTagCloud(),
                Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                PreferredGenreList(),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}