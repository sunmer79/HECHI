import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookDetailPage extends StatelessWidget {
  final String bookTitle;
  final String author;
  final String imageUrl; // ⭐ 추가됨
  final String rating;   // ⭐ 추가됨

  const BookDetailPage({
    super.key,
    required this.bookTitle,
    required this.author,
    required this.imageUrl, // ⭐ 추가됨
    required this.rating,   // ⭐ 추가됨
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('도서 상세 정보', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // 책 표지 크게 보여주기
            Container(
              width: 160,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (e, s) {},
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                bookTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            // 저자
            Text(
              '$author 저',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            // 평점
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '여기에 책 소개글이나 상세 내용이 들어갑니다.\nAPI에서 줄거리(description)를 제공한다면 여기에 표시하면 됩니다.',
                style: TextStyle(height: 1.6, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}