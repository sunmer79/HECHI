import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class PreferredGenreList extends GetView<TasteAnalysisController> {
  const PreferredGenreList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("독서 선호 장르", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3F3F))),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.genreRankings.isEmpty) return const Center(child: Text("아직 평가된 장르가 없습니다.", style: TextStyle(color: Colors.grey)));

            final top3 = controller.genreRankings.take(3).toList();
            final others = controller.genreRankings.skip(3).toList();

            String to100Score(double score5) => (score5 * 20).round().toString();

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
        ],
      ),
    );
  }
}