import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';

class CommentSection extends GetView<BookDetailController> {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 전체 위젯을 하나의 Obx로 감싸서 모든 로직이 반응형 범위 내에 있게 함
    return Obx(() {
      final reviewCount = controller.reviews.length; // controller.book.value.reviewCount; // 현재 리뷰 개수
      final displayLimit = 3; //화면에 표시한 최대 리뷰 개수
      final visibleItemCount = reviewCount > displayLimit ? displayLimit : reviewCount; // 표시할 개수
      final hasMoreToReviews = reviewCount > displayLimit; // '모두보기' 버튼 표시 여부

      // 그래프 데이터
      final histogram =
        Map<String, dynamic>.from(controller.book["rating_histogram"] ?? {});
      final maxCount = controller.maxRatingCount.value;

      // 로직이 Obx 내부에 있으므로, 로딩 중이면 null을 리턴하거나 로딩 위젯을 넣을 수 있습니다.
      if (controller.isLoading.value) {
        // 이 부분은 이미 상위 페이지에서 처리되지만, 안전을 위해 남겨둡니다.
        // return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 코멘트 타이틀
          Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFABABAB)),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '코멘트',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                        "$reviewCount",
                        style : const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF717171),
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        )
                    )
                  ]
              )
          ),

          // 평점 그래프 + 평균 별점 영역
          Container(
            width: double.infinity,
            color: const Color(0x4CD1ECD9),
            padding: const EdgeInsets.fromLTRB(17, 20, 17, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('평균 평점', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      '${controller.book["average_rating"] ?? "-"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Expanded(child: _buildRatingGraph(histogram as Map<String, dynamic>, maxCount)), // ⭐ 오른쪽 정렬 및 공간 균등 사용
              ],
            ),
          ),

          // 리뷰 리스트
          // 1. 리뷰가 없을 경우
          if (reviewCount == 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 35),
              decoration: BoxDecoration(
                color: const Color(0x4DD4D4D4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "첫 번째 리뷰를 남겨보세요!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleItemCount,
                itemBuilder: (_, index) =>
                    ReviewItemDisplay(review: controller.reviews[index]),
            ),

          // 모두보기 버튼 (리뷰가 4개 이상일 때만)
          if (hasMoreToReviews)
            InkWell(
              onTap: () => Get.snackbar("알림", "전체 리뷰 페이지로 이동합니다."),
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x66D1ECD9),
                  border: Border(
                    top: BorderSide(width: 1, color: Color(0xFFABABAB)),
                    bottom: BorderSide(width: 1, color: Color(0xFFABABAB)),
                  ),
                ),
                child: const Text(
                  '모두보기',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
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

// --------------------------------------------------------------------
// 개별 리뷰 항목의 상태를 로컬 Rx로 관리 (ReviewItemDisplay)
// --------------------------------------------------------------------
class ReviewItemDisplay extends StatelessWidget {
  final Map<String, dynamic> review;
  ReviewItemDisplay({super.key, required this.review});

  // 로컬 상태를 Rx로 선언 (StatelessWidget 내부에 final로 선언)
  final RxBool isExpanded = false.obs;          // ✅ [수정] maxLines 확장에 사용 (5 -> 20)
  final RxBool isSpoilerVisible = false.obs;    // ✅ [유지] 스포일러 보기 상태
  final RxBool isLiked = false.obs;
  late final RxInt likeCount =
      (review["like_count"] ?? 0).obs; // 로컬 좋아요 카운트

  static const int maxInitialLines = 5;
  static const int maxExpandedLines = 20;

  // --- Helper Methods (유지) ---
  bool _isTextClipped(String text, BoxConstraints constraints, TextStyle style, int lineLimit) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: lineLimit,
      locale: const Locale('ko'),
    )..layout(maxWidth: constraints.maxWidth);
    return painter.didExceedMaxLines;
  }

  List<Widget> _buildStars(double rating) {
    List<Widget> stars = [];
    double currentRating = rating;
    for (int i=1; i<=5; i++){
      if (currentRating >= 1) { stars.add(const Icon(Icons.star, size: 14, color: Color(0xFFFFD700))); currentRating -= 1; }
      else if (currentRating >= 0.5) { stars.add(const Icon(Icons.star_half, size: 14, color: Color(0xFFFFD700))); currentRating -= 0.5; }
      else { stars.add(const Icon(Icons.star_border, size: 14, color: Color(0xFFE0E0E0))); }
    }
    return stars;
  }

  void _toggleLike(int bookId, int reviewId) {
    if (isLiked.value) {
      likeCount.value--;
    } else {
      likeCount.value++;
    }
    isLiked.value = !isLiked.value;
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 13, height: 1.4);

    return Obx(() { // ✅ Obx 시작: isSpoilerVisible, isExpanded, isLiked 모두 감지
      final spoilerVisible = isSpoilerVisible.value;
      final expanded = isExpanded.value; // ✅ [수정] 변수명 통일: isExpanded.value로 직접 접근

      final currentMaxLines = spoilerVisible || expanded ? maxExpandedLines : maxInitialLines;
      final Color likeColor = isLiked.value ? const Color(0xFF4D856C) : const Color(0xFF717171);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 별점 + 이름 (유지)
            Row(
              children: [
                Row(children: _buildStars((review["rating"] ?? 0).toDouble())),
                const Spacer(),
                Text("User ${review["user_id"]}", style: const TextStyle(fontSize: 12, color: Color(0xFF717171))),
                const SizedBox(width: 6),
                const Icon(Icons.account_circle, size: 20, color: Color(0xFF717171)),
              ],
            ),
            const SizedBox(height: 8),

            // ------------------------------------------------
            // 1. 스포일러 처리
            // ------------------------------------------------
            if ((review["is_spoiler"] ?? false) && !spoilerVisible) // ✅ 가림막 상태
              Row(
                children: [
                  const Text('스포일러가 포함되어 있습니다.', style: TextStyle(fontSize: 13, color: Colors.black)),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => isSpoilerVisible.value = true, // ✅ 상태 변경으로 else 블록 즉시 실행
                    child: const Text('보기', style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            else
            // 2. 내용 더보기 처리 (LayoutBuilder 사용)
              LayoutBuilder(
                builder: (context, constraints) {
                  final clippedAtFive = _isTextClipped(review["content"] ?? "", constraints, style, maxInitialLines);
                  final clippedAtTwenty = _isTextClipped(review["content"] ?? "", constraints, style, maxExpandedLines);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review["content"] ?? "",
                        maxLines: currentMaxLines, // ✅ spoilerVisible 상태가 currentMaxLines를 제어
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ),

                      // 5줄에서 20줄로 확장하는 '더보기' 버튼
                      if (clippedAtFive && !expanded) // ✅ expanded로 변경
                        GestureDetector(
                          onTap: () => isExpanded.value = true,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text("더보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        )

                      // 20줄 확장 후, 여전히 내용이 길다면 최종 '전체 보기' 버튼
                      else if (expanded && clippedAtTwenty)
                        GestureDetector(
                          onTap: () => Get.toNamed("/review/detail", arguments: review["id"] ?? 0),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text("전체보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 8),

            // 좋아요/댓글
            Row(
              children: [
                // 좋아요 버튼 (토글 기능 연결)
                GestureDetector(
                  onTap: () => _toggleLike(review["book_id"] ?? 0, review["id"] ?? 0),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked.value ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                              size: 14,
                              color: likeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                                "${likeCount.value}",
                                style: TextStyle(color: likeColor, fontSize: 13)
                            )
                          ]
                      )
                  ),
                ),
                const SizedBox(width: 15),

                const Icon(Icons.comment_outlined, size: 14, color: Color(0xFF717171)),
                const SizedBox(width: 4),
                const Text("0", style: TextStyle(color: Color(0xFF717171), fontSize: 13)),
              ],
            )
          ],
        ),
      );
    });
  }
}