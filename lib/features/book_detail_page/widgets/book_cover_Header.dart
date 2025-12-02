import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';

class BookCoverHeader extends GetView<BookDetailController> {
  const BookCoverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller의 book 데이터 사용
    final book = controller.book;

    final coverUrl = book.value["thumbnail"] ?? "";   // ⭐ JSON key 접근
    return Stack(
      children: [
        // 이미지 영역
        Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xFFF0F0F0),
          child: coverUrl.isNotEmpty
              ? Image.network(
            coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          )
              : const Center(child: Icon(Icons.book, size: 50, color: Colors.grey)),
        ),
        // 하단 그라데이션 (텍스트 가독성용)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(0.0), Colors.white],
              ),
            ),
          ),
        ),
      ],
    );
  }
}