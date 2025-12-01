import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';
import 'package:hechi/core/widgets/bottom_bar.dart';

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
        title: const Text('HECHI님의 취향분석', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreenHeader(),

            // 1. 평가 수 (패딩 17, 간격 8)
            _buildCountSection(),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),

            // 2. 별점 분포 (하단 통계 패딩 17, 간격 16)
            _buildStarSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            _buildTimeSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            _buildTagSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            _buildGenreSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      color: const Color(0xFF4DB56C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("HECHI PEDIA", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("취향분석", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF4DB56C), size: 20)),
              const SizedBox(width: 10),
              const Text("HECHI", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ [수정 1] 평가 수: 전체 패딩 17, 아이템 사이 간격 8 (좌4 + 우4)
  Widget _buildCountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 17), // 전체 패딩 17
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("평가 수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildExpandedCountItem('소설', controller.countStats['소설']!),
              const SizedBox(width: 8), // 좌4 + 우4 = 8
              _buildExpandedCountItem('시', controller.countStats['시']!),
              const SizedBox(width: 8),
              _buildExpandedCountItem('에세이', controller.countStats['에세이']!),
              const SizedBox(width: 8),
              _buildExpandedCountItem('만화', controller.countStats['만화']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedCountItem(String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text("$value", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  // ✅ [수정 2] 별점 분포: 하단 통계 패딩 17, 간격 16 (좌8 + 우8)
  Widget _buildStarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24), // 제목은 기존 패딩 유지
            child: const Text("별점 분포", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          ),
          const SizedBox(height: 15),

          // 그래프 영역 (여기는 기존 패딩 유지)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
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
                            SizedBox(
                                width: 12,
                                child: Text("${d['score']}", style: const TextStyle(color: Colors.grey, fontSize: 12))
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
                      )).toList(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Summary", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryItem("${controller.averageRating}", "${controller.totalReviews} Reviews", isLarge: true, showStar: true),
                          const SizedBox(height: 20),
                          _buildSummaryItem(controller.readingRate, "Reading rate", isLarge: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🔻 여기가 요청하신 하단 통계 수정 부분!
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17), // 컨테이너 패딩 17
            child: Row(
              children: [
                _buildExpandedBottomStat("4.2", "별점 평균"),
                const SizedBox(width: 16), // 좌8 + 우8 = 16
                _buildExpandedBottomStat("30", "별점 개수"),
                const SizedBox(width: 16), // 좌8 + 우8 = 16
                _buildExpandedBottomStat("4.0", "많이 준 별점"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedBottomStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
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
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                const TextSpan(text: "총 "),
                TextSpan(text: "${controller.totalReadingTime} 시간", style: const TextStyle(color: Color(0xFF4DB56C), fontWeight: FontWeight.bold)),
                const TextSpan(text: " 동안 감상하셨습니다."),
              ],
            ),
          ),
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
              return Align(
                alignment: align is Alignment ? align : Alignment.center,
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
        child: Column(
          children: [
            const Center(child: Text("인생은 역시 한 편의 책!", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14))),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: controller.genreRankings.take(3).map((e) => Column(
                children: [
                  Text(e['genre'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
                  const SizedBox(height: 4),
                  Text("${e['score']}점 - ${e['count']}편", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              )).toList(),
            ),
            const SizedBox(height: 30),
            ...controller.genreRankings.skip(3).map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e['genre'] as String, style: const TextStyle(fontSize: 16, color: Color(0xFF3F3F3F))),
                  Text("${e['score']}점 - ${e['count']}편", style: const TextStyle(fontSize: 14, color: Color(0xFF3F3F3F))),
                ],
              ),
            )).toList(),
          ],
        ),
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