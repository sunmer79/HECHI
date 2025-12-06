import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/review_list_controller.dart';
import 'option_bottom_sheet.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isMyReview; // 내 리뷰 여부
  final Function(int)? onLikeToggle; // 좋아요

  final Function(int)? onEdit;
  final Function(int)? onDelete;

  // 로컬 상태
  final RxBool isExpanded = false.obs;
  final RxBool isSpoilerVisible = false.obs;
  final RxBool isLiked = false.obs;
  late final RxInt likeCount;

  static const int maxInitialLines = 5;
  static const int maxExpandedLines = 20;

  ReviewCard({
    super.key,
    required this.review,
    this.isMyReview = false,
    this.onLikeToggle,
    this.onEdit,
    this.onDelete,
  }) {
    likeCount = RxInt(review["like_count"] is int ? review["like_count"] : 0);
    if (isMyReview)
      isSpoilerVisible.value = true;
  }

  // 텍스트 길이 측정 헬퍼
  bool _isTextClipped(String text, BoxConstraints constraints, TextStyle style, int lineLimit) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: lineLimit,
      locale: const Locale('ko'),
    )..layout(maxWidth: constraints.maxWidth);
    return painter.didExceedMaxLines;
  }

  void _toggleLike() {
    if (isLiked.value) likeCount.value--;
    else likeCount.value++;
    isLiked.value = !isLiked.value;
    if (onLikeToggle != null) onLikeToggle!(review['id']);
  }

  @override
  Widget build(BuildContext context) {
    final int reviewId = review['id'];
    const style = TextStyle(color: Colors.black, fontSize: 13, height: 1.54, letterSpacing: 0.25);

    return Obx(() {
      final spoilerVisible = isSpoilerVisible.value;
      final expanded = isExpanded.value;
      final currentMaxLines = spoilerVisible || expanded ? maxExpandedLines : maxInitialLines;
      final Color likeColor = isLiked.value ? const Color(0xFF4DB56C) : const Color(0xFF717171);

      return InkWell(
        onTap: () { Get.toNamed('/review_detail_page', arguments: review); },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F3F3))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 헤더 (닉네임, 별점, 더보기)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['user_nickname'] ?? "User ${review['user_id']}",
                            style: const TextStyle(color: Color(0xFF3F3F3F), fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          RatingBarIndicator(
                            rating: (review['rating'] as num).toDouble(),
                            itemBuilder: (context, index) => const Icon(Icons.star_rounded, color: Color(0xFFFFD700)),
                            itemCount: 5,
                            itemSize: 14.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                    // 더보기 버튼 (내 리뷰일 때만)
                    if (review['is_my_review'] == true) // 데이터에 따라 처리
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            OptionBottomSheet(
                              onEdit: () => onEdit?.call(reviewId),
                              onDelete: () => onDelete?.call(reviewId),
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        child: const Icon(Icons.more_horiz, size: 20, color: Color(0xFFDADADA)),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // 2. 내용 (스포일러 & 더보기 로직 적용)
                if ((review["is_spoiler"] ?? false) && !spoilerVisible)
                  Row(
                    children: [
                      const Text("스포일러가 포함되어 있습니다.", style: TextStyle(color: Colors.black, fontSize: 13)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => isSpoilerVisible.value = true,
                        child: const Text("보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final content = review['content'] ?? "";
                      final clippedAtFive = _isTextClipped(content, constraints, style, maxInitialLines);
                      final clippedAtTwenty = _isTextClipped(content, constraints, style, maxExpandedLines);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content,
                            maxLines: currentMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: style,
                          ),
                          // 더보기 버튼
                          if (clippedAtFive && !expanded)
                            GestureDetector(
                              onTap: () => isExpanded.value = true,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text("더보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            )
                          // 전체보기 버튼 (상세 페이지로 이동)
                          else if (expanded && clippedAtTwenty)
                            GestureDetector(
                              onTap: () => Get.toNamed("/review/detail", arguments: reviewId),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text("전체보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 10),

                // 3. 하단 (좋아요, 댓글)
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(isLiked.value ? Icons.thumb_up : Icons.thumb_up_alt_outlined, size: 14, color: likeColor), // 아이콘 변경 가능
                          const SizedBox(width: 6),
                          Text("${likeCount.value}", style: TextStyle(color: likeColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        const Icon(Icons.comment_outlined, size: 14, color: Color(0xFF717171)), // 아이콘 변경 가능
                        const SizedBox(width: 6),
                        Text("${review['comment_count'] ?? 0}", style: const TextStyle(color: Color(0xFF717171), fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    });
  }
}