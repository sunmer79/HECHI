import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';
import 'change_confirm_dialog.dart';

class RecentBookListWidget extends GetView<ReadingRegistrationController> {
  const RecentBookListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 명시적으로 컨트롤러 찾기
    final controller = Get.find<ReadingRegistrationController>();

    return Column(
      children: [
        // 1. 헤더 영역
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "최근 연결된 도서 목록",
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: controller.navigateToRecentBooksList,
              icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF333333)),
            )
          ],
        ),
        const SizedBox(height: 10),

        // 2. 리스트 영역
        SizedBox(
          height: 180,
          child: Obx(() {
            // [수정] 목록이 비어있을 경우
            if (controller.recentBooks.isEmpty) {
              return Container(
                width: double.infinity,
                alignment: Alignment.center,
                // [수정] decoration(배경색) 제거 -> 투명/기존 배경 유지
                child: const Text(
                  "최근 연결된 도서가 없습니다.",
                  style: TextStyle(
                    color: Color(0xFFAAAAAA), // 텍스트 색상만 회색으로 유지
                    fontSize: 14,
                  ),
                ),
              );
            }

            // 목록이 있을 경우 기존 리스트 출력
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentBooks.length,
              separatorBuilder: (ctx, idx) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final book = controller.recentBooks[index];

                return GestureDetector(
                  onTap: () {
                    final currentBook = controller.connectedBook.value;

                    if (currentBook != null) {
                      _showChangePopup(
                        context,
                        currentTitle: currentBook['title'],
                        newBook: book,
                      );
                    } else {
                      controller.connectBook(book);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 90,
                          height: 130,
                          color: Colors.grey[200],
                          child: Image.network(
                            book['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.book)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 90,
                        child: Text(
                          book['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF111111),
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showChangePopup(BuildContext context, {required String currentTitle, required Map<String, dynamic> newBook}) {
    final controller = Get.find<ReadingRegistrationController>();

    Get.dialog(
      ChangeConfirmDialog(
        currentTitle: currentTitle,
        newTitle: newBook['title'],
        onConfirm: () {
          Get.back(); // 팝업 닫기
          controller.connectBook(newBook);
        },
        onCancel: () {
          Get.back(); // 팝업 닫기
        },
      ),
      barrierDismissible: true,
    );
  }
}