import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

import '../../customer_service/pages/customer_service_page.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';

import '../controllers/my_read_controller.dart';

class MyReadView extends StatelessWidget {
  const MyReadView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyReadController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // ✅ [수정 완료] 설정 아이콘 클릭 시 -> Settings 페이지로 이동
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(controller),
            const SizedBox(height: 20),

            _buildActivityStats(controller),

            const SizedBox(height: 20),

            Container(height: 8, color: const Color(0xFFF5F5F5)),

            _buildSectionHeader("보관함"),
            _buildArchiveLink(),

            Container(height: 8, color: const Color(0xFFF5F5F5)),

            _buildSectionHeader("취향 분석"),
            _buildTasteAnalysisPreview(controller),

            _buildInsightTagCloud(controller),

            _buildSeeAllTasteButton(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(MyReadController controller) {
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
              profile['nickname'] ?? 'HECHI',
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

  Widget _buildActivityStats(MyReadController controller) {
    return Obx(() {
      final stats = controller.activityStats;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(stats['evaluations'] ?? 0, "평가"),
            ),
            Container(width: 1, height: 24, color: const Color(0xFFEEEEEE)),
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

  Widget _buildTasteAnalysisPreview(MyReadController controller) {
    return Obx(() {
      if (controller.ratingDistData.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text("아직 취향 분석 데이터가 충분하지 않습니다.", style: TextStyle(color: Colors.grey)),
        );
      }

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
                    children: controller.ratingDistData.map((d) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              child: Text("${d['score']}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                // ✅ [수정] 모서리 반경 4 -> 7로 변경 (TasteAnalysis와 통일)
                                borderRadius: BorderRadius.circular(7),
                                child: LinearProgressIndicator(
                                  value: (d['ratio'] as num).toDouble(),
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  color: Color(d['color'] as int),
                                  // ✅ [수정] 두께 8 -> 12로 변경 (TasteAnalysis와 통일)
                                  minHeight: 12,
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
                            controller.averageRating.value,
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
                        "${controller.totalReviews.value} Reviews",
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.readingRate.value,
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

  Widget _buildInsightTagCloud(MyReadController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("독서 선호 태그", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              children: controller.insightTags.map((tag) {
                final align = tag['align'];
                final alignment = align is Alignment ? align : Alignment.center;
                return Align(
                  alignment: alignment,
                  child: Text(
                    tag['text'] as String,
                    style: TextStyle(
                      fontSize: (tag['size'] as num).toDouble(),
                      color: Color(tag['color'] as int),
                      fontWeight: (tag['size'] as num) > 20 ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
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