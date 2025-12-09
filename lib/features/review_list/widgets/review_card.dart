import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/review_list_controller.dart';
import 'option_bottom_sheet.dart';

enum ReviewCardType {
  simple,
  detail,
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isMyReview;
  final Function(int)? onLikeToggle;
  final Function(int)? onEdit;
  final Function(int)? onDelete;

  // 로컬 상태
  final RxBool isExpanded = false.obs;
  final RxBool isSpoilerVisible = false.obs;

  static const int maxInitialLines = 5;
  static const int maxExpandedLines = 20;
  late final RxBool isLiked;
  late final RxInt likeCount;

  final ReviewCardType type;

  ReviewCard({
    super.key,
    required this.review,
    this.isMyReview = false,
    this.onLikeToggle,
    this.onEdit,
    this.onDelete,
    this.type = ReviewCardType.detail,
  }) {
    isLiked = RxBool(review["is_liked"] ?? false);
    likeCount = RxInt((review["like_count"] is int) ? review["like_count"] : 0);
    // if (isMyReview) isSpoilerVisible.value = true;
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
    isLiked.value = !isLiked.value;
    if (isLiked.value) {
      likeCount.value++;
    } else {
      likeCount.value--;
    }
    if (onLikeToggle != null) onLikeToggle!(review['id']);
  }

  @override
  Widget build(BuildContext context) {
    const contentStyle = TextStyle(color: Colors.black, fontSize: 14, height: 1.5, letterSpacing: 0.25);
    final double rating = (review["rating"] as num?)?.toDouble() ?? 0.0;

    return Obx(() {
      final spoilerVisible = isSpoilerVisible.value;
      final expanded = isExpanded.value;

      final Color activeColor = const Color(0xFF4DB56C);
      final Color inactiveColor = const Color(0xFF9E9E9E);
      final Color currentColor = isLiked.value ? activeColor : inactiveColor;
      final IconData currentIcon = isLiked.value ? Icons.thumb_up : Icons.thumb_up_alt_outlined;

      return Material(
        color: Colors.white,
        child: InkWell(
          onTap: () { Get.toNamed('/review_detail', arguments: review['id']); },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: 17,
                vertical: (type == ReviewCardType.simple) ? 15 : 20
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: (type == ReviewCardType.simple)
                  ? null
                  : const Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F3F3))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==============================
                // 1. 헤더 (프로필, 닉네임, 날짜, 별점)
                // ==============================
                if (type == ReviewCardType.simple) ...[
                  _buildSimpleHeader(rating),
                ] else ...[
                    _buildDetailHeader(rating),
                    const SizedBox(height: 12),
                ],

                // ==============================
                // 2. 내용 (스포일러 & 더보기 로직)
                // ==============================
                if ((review["is_spoiler"] ?? false) && !spoilerVisible)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        const Text("스포일러가 포함되어 있습니다.", style: TextStyle(color: Color(0xFF717171), fontSize: 13)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => isSpoilerVisible.value = true,
                          child: const Text("보기", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final content = review['content'] ?? "";
                      final clippedAtFive = _isTextClipped(content, constraints, contentStyle, maxInitialLines);
                      final clippedAtTwenty = _isTextClipped(content, constraints, contentStyle, maxExpandedLines);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content,
                            maxLines: (spoilerVisible || expanded) ? maxExpandedLines : maxInitialLines,
                            overflow: TextOverflow.ellipsis,
                            style: contentStyle,
                          ),
                          // 더보기 버튼
                          if (clippedAtFive && !expanded)
                            GestureDetector(
                              onTap: () => isExpanded.value = true,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text("더보기", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, decoration: TextDecoration.underline)),
                              ),
                            )
                          // 전체보기 (상세 이동)
                          else if (expanded && clippedAtTwenty)
                            GestureDetector(
                              onTap: () => Get.toNamed("/review/detail", arguments: review['id']),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text("전체보기", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, decoration: TextDecoration.underline)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 16),

                // ==============================
                // 3. 하단 액션바 (좋아요, 댓글)
                // ==============================
                Row(
                  children: [
                    // 좋아요
                    if (type == ReviewCardType.simple)
                      _buildSimpleBottom(currentIcon, currentColor)
                    else
                      _buildDetailBottom(currentColor)
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSimpleHeader(double rating){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (rating > 0)
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) => const Icon(Icons.star_rounded, color: Color(0xFFFFD700)),
            itemCount: 5,
            itemSize: 14.0,
            direction: Axis.horizontal,
          ),
        Row(
          children: [
            Text(
                review['user_nickname'] ?? "User ${review['user_id']}",
                style: const TextStyle(
                    color: Color(0xFF717171),
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF4DB56C).withOpacity(0.5),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailHeader(double rating){
    final String date = (review['created_at'] ?? '').toString().split('T')[0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 프로필 이미지
        CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFF4DB56C).withOpacity(0.5),
          child: const Icon(Icons.person, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 10),

        // 정보 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 닉네임, 날짜
              Row(
                children: [
                  Text(
                    review['user_nickname'] ?? "User ${review['user_id']}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              if (rating > 0)
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => const Icon(Icons.star_rounded, color: Color(0xFFFFD700)),
                  itemCount: 5,
                  itemSize: 14.0,
                  direction: Axis.horizontal,
                ),
            ],
          ),
        ),

        // 더보기 버튼 (내 리뷰일 때)
        if (isMyReview)
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                OptionBottomSheet(
                  reviewId: review['id'],
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
                backgroundColor: Colors.transparent,
              );
            },
            child: const Icon(Icons.more_horiz, size: 20, color: Color(0xFFBDBDBD)),
          ),
      ],
    );
  }

  Widget _buildSimpleBottom(IconData currentIcon, Color currentColor){
    return Row (
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Row(
            children: [
              Icon(currentIcon, size: 16, color: currentColor),
              const SizedBox(width: 4),
              Text("${likeCount.value}", style: TextStyle(color: currentColor, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 댓글
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFF9E9E9E)),
            const SizedBox(width: 4),
            Text("${review['comment_count'] ?? 0}", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailBottom(Color currentColor) {
    return Row (
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Row(
            children: [
              const SizedBox(width: 4),
              Text("좋아요 ${likeCount.value}", style: TextStyle(color: currentColor, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 댓글
        Row(
          children: [
            const SizedBox(width: 4),
            Text("댓글 ${review['comment_count'] ?? 0}", style: const TextStyle(color: Color(0xFF717171), fontSize: 13)),
          ],
        ),
      ],
    );
  }
}