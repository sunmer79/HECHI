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
    // ✅ [수정] permanent: true 제거 (페이지 접속 시마다 컨트롤러 로직 수행)
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
              _buildProfileHeader(controller),
              const SizedBox(height: 20),

              _buildActivityStats(controller),

              const SizedBox(height: 20),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              _buildSectionHeader("보관함"),
              _buildArchiveLink(),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              // 캘린더 섹션
              _buildCalendarSection(controller),

              Container(height: 8, color: const Color(0xFFF5F5F5)),

              _buildSectionHeader("취향 분석"),
              // ✅ [수정] 개편된 취향 분석 UI 적용
              _buildTasteAnalysisPreview(controller),

              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              _buildSeeAllTasteButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // 1. 프로필 및 상단 통계 위젯
  // -----------------------------------------------------------------------

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
                Expanded(child: _buildOutlineBtn("프로필 수정", Icons.edit, onTap: () => Get.to(() => const ProfileEditView()))),
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
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatItem(controller.activityStats['evaluations'] ?? 0, "평가")),
          Container(width: 1, height: 24, color: const Color(0xFFEEEEEE)),
          Expanded(child: _buildStatItem(controller.activityStats['comments'] ?? 0, "코멘트")),
        ],
      ),
    ));
  }

  Widget _buildStatItem(int count, String label) {
    return Column(
      children: [
        Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
    );
  }

  Widget _buildArchiveLink() {
    return InkWell(
      onTap: () => Get.to(() => const BookStorageView(), binding: BookStorageBinding()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("보관함으로 이동하기", style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // 2. 캘린더 섹션 (수정된 요일 표기 반영)
  // -----------------------------------------------------------------------

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
              Obx(() => Text("${controller.currentMonth.value}월 캘린더", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F)))),
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
          // ✅ Mon, Tue 형태로 변경됨
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) {
              return Expanded(
                child: Center(
                  child: Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Obx(() => _buildCalendarGrid(controller)),
          const SizedBox(height: 40),
          InkWell(
            onTap: () => Get.toNamed(Routes.calendar),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.7),
      itemCount: startOffset + totalDays,
      itemBuilder: (context, index) {
        if (index < startOffset) return const SizedBox();
        final day = index - startOffset + 1;
        final hasBook = controller.calendarBooks.containsKey(day);
        final bookImageUrl = controller.calendarBooks[day];

        return Column(
          children: [
            if (hasBook && bookImageUrl != null && bookImageUrl.isNotEmpty)
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(bookImageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]))))
            else
              const Spacer(),
            const SizedBox(height: 4),
            if (!hasBook) Text("$day", style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        );
      },
    );
  }

  // -----------------------------------------------------------------------
  // 3. ✅ [수정 완료] 취향 분석 미리보기 (그래프 확장 + 하단 통계 3종)
  // -----------------------------------------------------------------------

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
            // #별점분포 태그
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
            const SizedBox(height: 20),

            // 1. 별점 그래프 (가로 꽉 차게 변경)
            Column(
              children: controller.ratingDistData.map((d) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text("${d['score']}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
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

            const SizedBox(height: 30),

            // 2. 하단 통계 (평균, 개수, 많이 준 별점)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomStatItem(controller.averageRating.value, "별점 평균"),
                _buildBottomStatItem(controller.totalReviews.value, "별점 개수"),
                _buildBottomStatItem(controller.mostGivenRating.value, "많이 준 별점"),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ✅ [신규] 하단 통계 아이템 위젯
  Widget _buildBottomStatItem(String value, String label) {
    return Column(
      children: [
        Text(
            value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500, // Medium
                color: Color(0xFF3F3F3F)
            )
        ),
        const SizedBox(height: 4),
        Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey)
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // 4. 태그 클라우드 및 버튼
  // -----------------------------------------------------------------------



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
                Text("모든 취향 분석 보기", style: TextStyle(color: Colors.grey, fontSize: 14)),
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