import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';

class CurrentBookWidget extends GetView<ReadingRegistrationController> {
  const CurrentBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final book = controller.connectedBook.value;

      // 1. 연결된 도서가 없을 때 (첫 번째 사진 스타일)
      if (book == null) {
        return Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)), // 연한 테두리
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu_book, size: 40, color: Color(0xFFCCCCCC)),
              SizedBox(height: 16),
              Text(
                "연결된 도서가 없습니다.",
                style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
              ),
              SizedBox(height: 4),
              Text(
                "최근 연결된 도서 목록에서 책을 선택하거나 \n검색 페이지에서 책을 찾아 등록해주세요.",
                style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
              ),
            ],
          ),
        );
      }

      // 2. 연결된 도서가 있을 때 (두 번째 사진 스타일)
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // 약간 회색 빛 배경 (사진 참고)
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 책 표지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 70,
                height: 100,
                color: Colors.grey[300], // Placeholder color
                child: Image.network(
                  book['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 정보 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Reading Now",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            // 연결 취소 아이콘 (링크 끊기)
            IconButton(
              onPressed: controller.disconnectBook,
              icon: const Icon(Icons.link_off, size: 28, color: Color(0xFF8E8E93)),
            ),
          ],
        ),
      );
    });
  }
}