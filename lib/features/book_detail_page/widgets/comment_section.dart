import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';
import '../../review_list/widgets/review_card.dart';

class CommentSection extends GetView<BookDetailController> {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reviewCount = controller.reviews.length;
      final hasMoreToReviews = reviewCount > 3;

      final bestReviews = controller.bestReviews;

      // 그래프 데이터
      final histogram = Map<String, dynamic>.from(controller.book["rating_histogram"] ?? {});
      final maxCount = controller.maxRatingCount.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 타이틀
          Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color(0xFFABABAB))),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                  children: [
                    const Text('코멘트', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text("$reviewCount", style: const TextStyle(fontSize: 18, color: Color(0xFF717171), fontWeight: FontWeight.w500)),
                  ]
              )
          ),

          // 2. 평점 그래프
          Container(
            width: double.infinity,
            color: const Color(0x4CD1ECD9),
            padding: const EdgeInsets.fromLTRB(17, 20, 17, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('평균 평점', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('${(controller.book["average_rating"] ?? 0).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 50),
                Expanded(child: _buildRatingGraph(histogram, maxCount)),
              ],
            ),
          ),

          // 3. 리뷰 리스트 (ReviewCard 재사용)
          if (reviewCount == 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 35),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
              ),
              child: const Center(child: Text("첫 번째 리뷰를 남겨보세요!", style: TextStyle(color: Colors.grey))),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bestReviews.length, // 최대 3개
              itemBuilder: (_, index) => ReviewCard(
                review: bestReviews[index],
                type: ReviewCardType.simple,
                onLikeToggle: (int id) {
                  controller.toggleLike(id);
                },
              ),
            ),

          // 4. 모두보기 버튼
          if (hasMoreToReviews)
            InkWell(
              onTap: () => Get.toNamed("/review/list", arguments: controller.bookId), // ✅ 전체 페이지 이동
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0x66D1ECD9),
                  border: Border(
                    top: BorderSide(width: 1, color: Color(0xFFABABAB)),
                    bottom: BorderSide(width: 1, color: Color(0xFFABABAB)),
                  ),
                ),
                child: const Text('모두보기', style: TextStyle(color: Colors.black, fontSize: 15)),
              ),
            ),
        ],
      );
    });
  }
}

// 그래프 생성
Widget _buildRatingGraph(Map<String, dynamic> histogram, int maxCount) {
  final List<double> scores = List.generate(10, (index) => 0.5 + (index * 0.5));

  return SizedBox(
      height: 120 + 18, // 막대 높이 + 점수 텍스
      child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 0.5점부터 5점까지 순서대로 막대 생성
                  ...scores.map(
                        (score) => _bar(
                      score,
                      histogram[score.toString()] ?? 0,
                      maxCount,
                    ),
                  ),
                ],
              ),
            ),
            // 2. 하단 점수 텍스트
            Container(
              height: 18,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 1.0, 2.0, 3.0, 4.0, 5.0 만 표시
                    const Expanded(child:SizedBox()),
                    Expanded(child: Text('1.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                    const Expanded(child:SizedBox()), // 1.0과 2.0 사이 간격
                    Expanded(child: Text('2.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                    const Expanded(child:SizedBox()), // 2.0과 3.0 사이 간격
                    Expanded(child: Text('3.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                    const Expanded(child:SizedBox()), // 3.0과 4.0 사이 간격
                    Expanded(child: Text('4.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                    const Expanded(child:SizedBox()), // 4.0과 5.0 사이 간격
                    Expanded(child: Text('5.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                  ]
              ),
            ),
          ]
      )
  );
}

// 막대 그래프
Widget _bar(double score, int count, int maxCount) {
  const double graphMaxHeight = 120.0; // 막대 최대 높이
  final double ratio = maxCount > 0 ? count / maxCount: 0.0;

  return Expanded(
    child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 8),
        child: FractionallySizedBox(
          heightFactor: ratio, // 비율에 따라 높이 결점 (최대 1.0)
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1), // bar 간 간격
            color: const Color(0xFF4DB56C),
          ),
        )
    ),
  );
}