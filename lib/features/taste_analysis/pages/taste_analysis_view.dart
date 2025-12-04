import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';
import '../../../../core/widgets/bottom_bar.dart';

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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreenHeader(),

              _buildCountSection(), // 평가 수
              const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),

              _buildStarSection(), // 별점 분포 및 하단 통계
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              _buildTimeSection(),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              _buildTagSection(),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              _buildGenreSection(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGreenHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      color: const Color(0xFF4DB56C),
      child: Obx(() {
        final nickname = controller.userProfile['nickname'] ?? 'HECHI';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$nickname PEDIA", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("취향분석", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                const CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF4DB56C), size: 20)),
                const SizedBox(width: 10),
                Text(nickname, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        );
      }),
    );
  }

  Widget _buildCountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("평가 수", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildExpandedCountItem('소설', controller.countStats['소설']!),
              _buildExpandedCountItem('시', controller.countStats['시']!),
              _buildExpandedCountItem('에세이', controller.countStats['에세이']!),
              _buildExpandedCountItem('만화', controller.countStats['만화']!),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildExpandedCountItem(String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text("$value", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("별점분포", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),

          const Center(child: Text("Summary", style: TextStyle(fontSize: 12, color: Colors.grey))),
          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    ...controller.starRatingDistribution.map((d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 12, child: Text("${d['score']}", style: const TextStyle(color: Colors.grey, fontSize: 12))),
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
                    )).toList(),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildSummaryItem(controller.averageRating.value, "${controller.totalReviews.value} Reviews", isLarge: true, showStar: true),
                    const SizedBox(height: 20),
                    _buildSummaryItem(controller.readingRate.value, "완독률", isLarge: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomStatItem(controller.averageRating.value, "별점 평균"),
              _buildBottomStatItem(controller.totalReviews.value, "별점 개수"),
              _buildBottomStatItem(controller.mostGivenRating.value, "많이 준 별점"),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildBottomStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSummaryItem(String value, String label, {bool isLarge = false, bool showStar = false}) {
    return Column(
      crossAxisAlignment: isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: isLarge ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: isLarge ? 24 : 20, fontWeight: FontWeight.bold, color: const Color(0xFF3F3F3F))),
            if (showStar) ...[const SizedBox(width: 4), const Icon(Icons.star, size: 20, color: Color(0xFF81C784))],
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: colSection(
        title: "독서 감상 시간",
        child: Center(
          child: Obx(() => RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                const TextSpan(text: "총 "),
                TextSpan(text: "${controller.totalReadingTime.value} 시간", style: const TextStyle(color: Color(0xFF4DB56C), fontWeight: FontWeight.bold)),
                const TextSpan(text: " 동안 감상하셨습니다."),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildTagSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: colSection(
        title: "독서 선호 태그",
        child: Container(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: controller.tags.map((tag) {
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
      ),
    );
  }

  Widget _buildGenreSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: colSection(
        title: "독서 선호 장르",
        child: Obx(() {
          if (controller.genreRankings.isEmpty) return const Center(child: Text("아직 평가된 장르가 없습니다.", style: TextStyle(color: Colors.grey)));

          final top3 = controller.genreRankings.take(3).toList();
          final others = controller.genreRankings.skip(3).toList();

          return Column(
            children: [
              const Center(child: Text("인생은 역시 한 편의 책!", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14))),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: top3.map((e) => Column(
                  children: [
                    Text(e.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
                    const SizedBox(height: 6),
                    Text("${e.average5.toStringAsFixed(0)}점 - ${e.reviewCount}편", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                )).toList(),
              ),
              const SizedBox(height: 30),

              ...others.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.name, style: const TextStyle(fontSize: 16, color: Color(0xFF3F3F3F))),
                    Text("${e.average5.toStringAsFixed(0)}점 - ${e.reviewCount}편", style: const TextStyle(fontSize: 14, color: Color(0xFF3F3F3F))),
                  ],
                ),
              )).toList(),
            ],
          );
        }),
      ),
    );
  }

  Widget colSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}