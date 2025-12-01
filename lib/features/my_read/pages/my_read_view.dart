import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

import '../../customer_service/pages/customer_service_page.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';

import '../controllers/my_read_controller.dart';

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
          // 설정 아이콘만 남김
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () => Get.to(() => CustomerServicePage()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // ✅ [수정] 2등분 된 통계 (평가/코멘트)
            _buildActivityStats(),

            const SizedBox(height: 20),

            Container(height: 8, color: const Color(0xFFF5F5F5)),

            _buildSectionHeader("보관함"),
            _buildArchiveLink(),

            Container(height: 8, color: const Color(0xFFF5F5F5)),

            _buildSectionHeader("취향 분석"),
            _buildTasteAnalysisPreview(),

            _buildInsightTags(),

            _buildSeeAllTasteButton(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final profile = controller.userProfile;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4DB56C), width: 2),
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFA5D6A7),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile['nickname'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildOutlineBtn("프로필 수정", Icons.edit)),
                const SizedBox(width: 8),
                Expanded(child: _buildOutlineBtn("공유", Icons.share)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOutlineBtn(String text, IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFEEEEEE)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == "공유") ...[
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 4)
          ],
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  // ✅ [수정] 컬렉션 삭제 및 2등분 (평가 | 코멘트)
  Widget _buildActivityStats() {
    return Obx(() {
      final stats = controller.activityStats;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24), // 전체 좌우 패딩
        child: Row(
          children: [
            // 1. 평가 (Expanded로 50% 차지)
            Expanded(
              child: _buildStatItem(stats['evaluations'] ?? 0, "평가"),
            ),

            // 구분선
            Container(width: 1, height: 24, color: const Color(0xFFEEEEEE)),

            // 2. 코멘트 (Expanded로 50% 차지)
            Expanded(
              child: _buildStatItem(stats['comments'] ?? 0, "코멘트"),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(int count, String label) {
    return Column(
      children: [
        Text("$count",
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F3F3F))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3F3F3F))),
    );
  }

  Widget _buildArchiveLink() {
    return InkWell(
      onTap: () {
        Get.to(
              () => const BookStorageView(),
          binding: BookStorageBinding(),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("보관함으로 이동하기",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTasteAnalysisPreview() {
    return Obx(() {
      if (controller.analyticsData.isEmpty) return const SizedBox();
      final summary = controller.analyticsData['rating_summary'];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF81C784),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text("#별점분포",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((score) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              child: Text("$score",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: controller.getRatingRatio(score),
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  color: score >= 4
                                      ? const Color(0xFF43A047)
                                      : const Color(0xFFA5D6A7),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${summary['average_5']}",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F3F3F)),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star,
                              color: Color(0xFF81C784), size: 18),
                        ],
                      ),
                      Text(
                        "${summary['total_reviews']} Reviews",
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${(summary['average_100'] as double).toInt()}%",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F3F3F)),
                      ),
                      const Text(
                        "Reading rate",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInsightTags() {
    return Obx(() {
      final insights = controller.userInsights;
      if (insights.isEmpty) return const SizedBox();

      final tags = List<String>.from(insights['tags'] ?? []);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: tags
              .map((tag) => Text(
            "#$tag",
            style: const TextStyle(
                color: Color(0xFF4DB56C),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ))
              .toList(),
        ),
      );
    });
  }

  Widget _buildSeeAllTasteButton() {
    return InkWell(
      onTap: () => Get.toNamed(Routes.tasteAnalysis),
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("모든 취향 분석 보기",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}