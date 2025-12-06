import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_note_controller.dart';
import '../widgets/bookmark_item.dart';
import '../widgets/dialogs/sort_bottom_sheet.dart';

class BookmarkPage extends GetView<BookNoteController> {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정렬 바 영역 (회색 바)
        GestureDetector(
          onTap: () {
            showSortBottomSheet(
              context,
              controller.bookmarkSort.value, // 'date' / 'page'
                  (selected) => controller.updateBookmarkSort(selected),
            );
          },
          child: Container(
            width: double.infinity,
            height: 50,
            color: const Color(0xFFF3F3F3),
            padding: const EdgeInsets.only(left: 17, right: 17),
            child: Row(
              children: [
                const Text(
                  '정렬',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF3F3F3F),
                  ),
                ),
                const Spacer(),
                Obx(
                      () => Text(
                    controller.bookmarkSort.value == 'date' ? '날짜 순' : '페이지 순',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF717171),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF3F3F3F),
                ),
              ],
            ),
          ),
        ),

        // 리스트
        Expanded(
          child: Obx(() {
            if (controller.isLoadingBookmarks.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.bookmarks.isEmpty) {
              return const Center(child: Text('북마크가 없습니다.'));
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.bookmarks.length,
              itemBuilder: (context, index) {
                final item = controller.bookmarks[index];
                return BookmarkItem(
                  id: item['id'] as int,
                  page: item['page'] as int,
                  percent: "${item['percent'] ?? item['progress'] ?? ''}%",
                  date: item['created_date'] ?? '',
                  onDelete: () => controller.deleteBookmark(item['id'] as int),
                  onMemo: () => controller.openBookmarkMemoEditor(item),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
