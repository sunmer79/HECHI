import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_note_controller.dart';
import '../widgets/bookmark_item.dart';
import '../widgets/dialogs/sort_bottom_sheet.dart';
import '../widgets/overlays/bookmark_creation_overlay.dart';

class BookmarkTab extends GetView<BookNoteController> {
  const BookmarkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildControlBar(context),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.bookmarks.isEmpty) {
              return const Center(
                child: Text("저장된 북마크가 없습니다.", style: TextStyle(color: Colors.grey)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: controller.bookmarks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final item = controller.bookmarks[index];
                return BookmarkItem(
                  data: item,
                  onDelete: () => controller.deleteItem('bookmark', item['id']),
                  onUpdate: (bookmark_id, page, memo) => controller.updateBookmark(item['id'], page, memo),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildControlBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.bottomSheet(
              const SortBottomSheet(),
              backgroundColor: Colors.transparent,
            ),
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Obx(() => Text(
                  controller.sortText,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                )),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                BookmarkCreationOverlay(onSubmit: controller.createBookmark),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            child: const Icon(Icons.edit, color: Colors.grey, size: 24),
          ),
        ],
      ),
    );
  }
}