import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

import '../../customer_service/pages/customer_service_page.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';

import '../controllers/my_read_controller.dart';
import 'profile_edit_view.dart';

class MyReadView extends StatelessWidget {
  const MyReadView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller 생성
    final controller = Get.put(MyReadController(), permanent: true);

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
      // 당겨서 새로고침 (Refresh)
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
              _buildProfileHeader(controller),
              const SizedBox(height: 20),

              _buildActivityStats(controller),

              const SizedBox(height: 20),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              _buildSectionHeader("보관함"),
              _buildArchiveLink(),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 캘린더 섹션 (이전 요청사항 반영)
              _buildCalendarSection(controller),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              _buildSectionHeader("취향 분석"),
              _buildTasteAnalysisPreview(controller),

              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // 태그 클라우드
              _buildInsightTagCloud(controller),

              _buildSeeAllTasteButton(),

              const SizedBox(height: 40),
            ],
          ),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              controller.description.value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildOutlineBtn("프로필 수정", Icons.edit, onTap: () {
                  Get.to(() => const ProfileEditView());
                })),
                const SizedBox(width: 8),
                Expanded(child: _buildOutlineBtn("공유", Icons.share)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOutlineBtn(String text, IconData icon, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
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
          Text(text, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w400)),
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
                fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
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

  // 캘린더 섹션 (아까 추가한 기능 유지)
  Widget _buildCalendarSection(MyReadController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, color: Colors.black54),
                onPressed: () => controller.changeMonth(-1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Obx(() => Text(
                  "${controller.currentMonth.value}월 캘린더",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))
              )),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_right, color: Colors.black54),
                onPressed: () => controller.changeMonth(1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Obx(() => _buildCalendarGrid(controller)),
          const SizedBox(height: 60),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.calendar);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("캘린더 전체 보기", style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(MyReadController controller) {
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
        childAspectRatio: 0.7,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    bookImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
                  ),
                ),
              )
            else
              const Spacer(),

            const SizedBox(height: 4),
            if (!hasBook)
              Text("$day", style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        );
      },
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
                      fontWeight: FontWeight.w500)),
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
                                borderRadius: BorderRadius.circular(7),
                                child: LinearProgressIndicator(
                                  value: (d['ratio'] as num).toDouble(),
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  color: Color(d['color'] as int),
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
                                fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3F3F3F)),
                      ),
                      const Text(
                        "완독률",
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

  // ✅ [수정] 태그 클라우드 섹션 (빈 상태 처리 포함)
  Widget _buildInsightTagCloud(MyReadController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("독서 선호 태그", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Obx(() {
              if (controller.totalReviews.value == "0" || controller.insightTags.isEmpty) {
                return const Center(child: Text("아직 분석된 태그가 없습니다.", style: TextStyle(color: Colors.grey)));
              }
              return Stack(
                children: controller.insightTags.map((tag) {
                  final align = tag['align'];
                  return Align(
                    alignment: align is Alignment ? align : Alignment.center,
                    child: Text(
                      tag['text'] as String,
                      style: TextStyle(
                        fontSize: (tag['size'] as num).toDouble(),
                        color: Color(tag['color'] as int),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
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