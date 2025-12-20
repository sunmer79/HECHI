import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';
import '../../../../core/widgets/bottom_bar.dart';
import 'dart:ui';
import 'dart:math';
import '../../../../core/widgets/star_rating_chart.dart';
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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

        return RefreshIndicator(
          color: const Color(0xFF4DB56C),
          onRefresh: () async {
            await controller.fetchData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreenHeader(),
                _buildCountSection(),
                const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
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
            Text("$nickname's Book", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("취향분석", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                const CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF4DB56C), size: 20
                )),
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
          const Text("평가 수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF0FDF0),
                  Color(0xFFE8F5E9),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Obx(() => Text(
                      controller.totalReviews.value,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4DB56C),
                      ),
                    )),
                    const SizedBox(width: 6),
                    const Text(
                      "권",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF4DB56C),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '지금까지 ${controller.userProfile['nickname'] ?? 'HECHI'}님이 읽고 평가한 책',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF4DB56C).withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TasteAnalysisView.dart 내부
  Widget _buildStarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("별점분포", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 5),

          // ✅ 공통 위젯 사용 (그래프가 다시 나타납니다!)
          Obx(() => StarRatingChart(
              ratingData: controller.starRatingDistribution,
              mostGivenRating: controller.mostGivenRating.value
          )),

          const SizedBox(height: 30),

          // 하단 통계
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
  }

  Widget _buildBottomStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
        child: Obx(() {
          if (controller.totalReviews.value == "0" || controller.tags.isEmpty) {
            return const Center(child: Text("아직 분석된 태그가 없습니다.", style: TextStyle(color: Colors.grey)));
          }

          const double stackHeight = 160;

          return SizedBox(
            height: stackHeight,
            width: double.infinity,
            child: Stack(
              children: controller.tags.map((tag) {
                double size = (tag['size'] as num).toDouble();
                Color color = Color(tag['color'] as int);
                Offset position = tag['position'] as Offset;

                return Positioned(
                  left: position.dx * 300,
                  top: position.dy * stackHeight,
                  child: Text(
                    tag['text'] as String,
                    style: TextStyle(
                      fontSize: size * 1.4,
                      color: color,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
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

          String to100Score(double score5) {
            return (score5 * 20).round().toString();
          }

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
                    Text("${to100Score(e.average5)}점 - ${e.reviewCount}편", style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
                    Text("${to100Score(e.average5)}점 - ${e.reviewCount}편", style: const TextStyle(fontSize: 14, color: Color(0xFF3F3F3F))),
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