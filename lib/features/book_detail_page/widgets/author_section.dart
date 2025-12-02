import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';

class AuthorSection extends GetView<BookDetailController> {
  const AuthorSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 데이터 가져오기
    final authors = List<String>.from(controller.book.value["authors"] ?? []);

    // 2. 데이터가 없을 경우 처리
    final displayAuthors = authors.isEmpty ? ["작가 미상"] : authors;

    // 3. 작가가 3명 이상인지 확인 (모아보기 버튼 표시 조건)
    final hasMoreAuthors = displayAuthors.length >= 3;

    // 4. 화면에 보여줄 작가 리스트 (3명 이상이면 2명만 자름)
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
        //모아보기 버튼 (작가가 3명 이상일 때만 표시)
        if (hasMoreAuthors)
          InkWell(
            onTap: () {
              Get.toNamed('/authors');  // ⭐ 전체 작가 페이지로 이동
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
      // 1. 프로필 아이콘 박스
      Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF89C99C),
          borderRadius: BorderRadius.circular(5),
          border: Border.all( // ⭐ 테두리 색상 & 굵기
            color: Color(0xFFD4D4D4), // 원하는 stroke 색상
            width: 1,                 // 테두리 두께
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

      // 2. 텍스트 정보
      Column(
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

      // 3. 화살표
      const Spacer(),
      const Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: Color(0xFF717171),
      ),
    ],
  );
}
