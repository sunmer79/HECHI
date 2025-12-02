import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Feature Widgets & Controller
import '../controllers/book_detail_controller.dart';
import '../widgets/book_cover_Header.dart';
import '../widgets/book_info_section.dart';
import '../widgets/action_buttons.dart';
import '../widgets/author_section.dart';
import '../widgets/comment_section.dart';

import '../../../core/widgets/bottom_bar.dart';

class BookDetailPage extends GetView<BookDetailController> {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar 제거됨
      bottomNavigationBar: const BottomBar(),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 데이터가 로드되면 화면 표시
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 커버 이미지
              const BookCoverHeader(),

              // 2. 책 정보 (제목, 평점, 메타정보)
              const BookInfoSection(),


              // 3. 액션 버튼 (읽고싶어요, 코멘트 등)
              const ActionButtons(),

              const Divider(thickness: 0.5, color: Color(0xFFD4D4D4)),

              // 4. 드래그 가능한 별점 위젯
              _buildInteractiveRatingBar(),

              const Divider(height: 8, thickness: 8, color: Color(0xFFD4D4D4)),

              // 5. 저자/역자 정보
              const AuthorSection(),

              const Divider(height: 8, thickness: 8, color: Color(0xFFD4D4D4)),

              // 6. 코멘트 섹션 (그래프 + 리뷰)
              const CommentSection(),

              // 하단 여백 확보
              const Divider(height: 8, thickness: 8, color: Color(0xFFD4D4D4)),
            ],
          ),
        );
      }),
    );
  }

  // flutter_rating_bar 적용
  Widget _buildInteractiveRatingBar() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(minWidth: 300),
          alignment: Alignment.center,

          // ✨ Obx와 KeyedSubtree 조합 (완벽합니다)
          child: Obx(() => KeyedSubtree(
            key: ValueKey(controller.myRating.value), // 값이 바뀌면 강제 리빌드
            child: RatingBar(
              initialRating: controller.myRating.value,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              // updateOnDrag: true, // 필요 시 주석 해제 (메인화면 수정 방지하려면 false)

              ratingWidget: RatingWidget(
                full: const Icon(Icons.star_rounded, color: Color(0xFFFFD700)),
                half: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(Icons.star_rounded, color: Color(0xFFD4D4D4)), // 배경 회색
                    Icon(Icons.star_half_rounded, color: Color(0xFFFFD700)), // 앞면 금색
                  ],
                ),
                empty: const Icon(Icons.star_rounded, color: Color(0xFFD4D4D4)),
              ),
              onRatingUpdate: (rating) {
                controller.updateMyRating(rating);
              },
            ),
          )),
        )
    );
  }
}