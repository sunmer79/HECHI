import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_note_controller.dart';

class BookInfoHeader extends GetView<BookNoteController> {
  const BookInfoHeader({super.key});

  String _formatAuthor(dynamic authorsData) {
    if (authorsData == null) return "";

    // 1. 리스트인 경우 (API가 ["작가1", "작가2"] 형태로 줄 때)
    if (authorsData is List) {
      if (authorsData.isEmpty) return "";

      final firstAuthor = authorsData[0].toString();

      if (authorsData.length == 1) {
        return firstAuthor; // 한 명이면 이름만
      } else {
        return "$firstAuthor 외 ${authorsData.length - 1}명"; // 여러 명이면 '외 N명'
      }
    }
    return authorsData.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        final book = controller.bookInfo;
        final authorText = _formatAuthor(book['authors']);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] ?? "",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authorText,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            // 표지 이미지
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
                image: book['thumbnail'] != null
                    ? DecorationImage(image: NetworkImage(book['thumbnail']), fit: BoxFit.cover)
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}