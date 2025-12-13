import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';

class AuthorSection extends GetView<BookDetailController> {
  const AuthorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authors = List<String>.from(controller.book.value["authors"] ?? []);

    final displayAuthors = authors.isEmpty ? ["작가 미상"] : authors;
    final hasMoreAuthors = displayAuthors.length >= 3;
    final visibleAuthors = hasMoreAuthors ? displayAuthors.take(2).toList() : displayAuthors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: const Text(
            '저자/역자',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.25,
            ),
          ),
        ),

        // 작가 리스트 생성
        Column(
          children: List.generate(visibleAuthors.length, (index) {
            return Padding(
              // 리스트 아이템 간 간격 15
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              child: _buildAuthorRow(visibleAuthors[index]),
            );
          }),
        ),
        // 모아보기 버튼
        if (hasMoreAuthors)
          InkWell(
            onTap: () {
              Get.toNamed('/authors');  // 전체 작가 페이지로 이동
            },
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
  }
}

Widget _buildAuthorRow(String name){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 프로필 아이콘
      Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF89C99C),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color(0xFFD4D4D4),
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50
          ),
        ),
      ),
      const SizedBox(width: 20),

      // 텍스트 정보
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                height: 1.33,
              ),
            ),
            const SizedBox(height: 2),
            const Text('작가',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF717171),
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                )
            ),
          ],
        ),
      ),

      // 화살표
      const Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: Color(0xFF717171),
      ),
    ],
  );
}
