import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';
import '../widgets/delete_confirm_dialog.dart';
import '../widgets/change_confirm_dialog.dart';

class RecentBooksView extends GetView<ReadingRegistrationController> {
  const RecentBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "최근 연결된 도서 목록",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // [수정] 목록이 비어있을 경우 Empty State 출력
        if (controller.recentBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.library_books_outlined, size: 60, color: Color(0xFFDDDDDD)),
                SizedBox(height: 16),
                Text(
                  "최근 연결된 도서가 없습니다.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
          );
        }

        // 목록이 있을 경우 기존 리스트 출력
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.recentBooks.length,
          separatorBuilder: (ctx, idx) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final book = controller.recentBooks[index];

            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                        Get.back();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 60,
                              height: 90,
                              color: Colors.grey[200],
                              child: Image.network(
                                book['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => const Icon(Icons.book),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              book['title'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111111)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeletePopup(context, book),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFF888888),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  void _showChangePopup(BuildContext context, {required String currentTitle, required Map<String, dynamic> newBook}) {
    Get.dialog(
      ChangeConfirmDialog(
        currentTitle: currentTitle,
        newTitle: newBook['title'],
        onConfirm: () {
          controller.connectBook(newBook);
          Get.back();
          Get.back();
        },
        onCancel: () {
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }

  void _showDeletePopup(BuildContext context, Map<String, dynamic> book) {
    Get.dialog(
      DeleteConfirmDialog(
        title: "정말 삭제하시겠습니까?",
        content: "삭제하면 해당 도서 독서 상태가 삭제됩니다.",
        onConfirm: () {
          controller.recentBooks.remove(book);
          Get.back();
          Get.snackbar(
            "삭제 완료",
            "도서가 목록에서 삭제되었습니다.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
        onCancel: () {
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }
}