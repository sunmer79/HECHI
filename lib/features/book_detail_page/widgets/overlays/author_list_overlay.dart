import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

class AuthorListOverlay extends StatelessWidget {
  final List<String> authors;

  const AuthorListOverlay({super.key, required this.authors});

  @override
  Widget build(BuildContext context){
    return Container(
        height: Get.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: authors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: _buildAuthorRow(authors[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildAuthorRow(String name){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 프로필 아이콘
      Container(
        width: 45,
        height: 45,
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
              size: 30
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
    ],
  );
}
