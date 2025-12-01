import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';

class BookInfoSection extends GetView<BookDetailController> {
  const BookInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final book = controller.book;
      if (book.isEmpty) return const SizedBox(); // 로딩 전 or 데이터 없음

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
            child: Text(
              book["title"] ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 0.71,
                letterSpacing: 0.10,
              ),
            ),
          ),

          // 2. 평점
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
            child: Row(
              children: [
                /*
                if (book.expectedRating > 0) ...[
                  Text(
                    '예상★${book.expectedRating}',
                    style: const TextStyle(
                      color: Color(0xFF4DB56C), // TextIcon-OnNormal-Primary
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                      letterSpacing: 0.25,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                */
                // 평균 평점
                Text(
                  '평균★${book["average_rating"] ?? 0}',
                  style: const TextStyle(
                    color: Color(0xFF717171), // TextIcon-OnNormal-NormalMidEmp
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.54,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),

          // 3. 메타 정보 박스
          Container(
            width: double.infinity,
            height: 62,
            decoration: const BoxDecoration(
              color: Color(0x4CD4D4D4),
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0xFFD4D4D4),),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoItem("ISBN", book["isbn"] ?? ""),
                  _buildInfoItem("출판일자", book["published_date"] ?? ""),
                  _buildInfoItem("쪽수", "${book["total_pages"] ?? 0}쪽"),
                  _buildInfoItem("카테고리", book["category"] ?? ""),
                  _buildInfoItem("언어", book["language"] ?? ""),
                  _buildInfoItem("출판사", book["publisher"] ?? ""),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80), // 최소 너비 보장
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF717171),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.54,
              letterSpacing: 0.25,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.54,
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}