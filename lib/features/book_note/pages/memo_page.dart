import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_note_controller.dart';
import '../widgets/memo_item.dart';
import '../widgets/dialogs/sort_bottom_sheet.dart';

class MemoPage extends GetView<BookNoteController> {
  const MemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정렬 바
        GestureDetector(
          onTap: () {
            showSortBottomSheet(
              context,
              controller.memoSort.value,
                  (selected) => controller.updateMemoSort(selected),
            );
          },
          child: Container(
            width: double.infinity,
            height: 50,
            color: const Color(0xFFF3F3F3),
            padding: const EdgeInsets.symmetric(horizontal: 17),
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
                    controller.memoSort.value == 'date' ? '날짜 순' : '페이지 순',
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

        Expanded(
          child: Obx(() {
            if (controller.isLoadingMemos.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.memos.isEmpty) {
              return const Center(child: Text('메모가 없습니다.'));
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.memos.length,
              itemBuilder: (context, index) {
                final item = controller.memos[index];
                return MemoItem(
                  id: item['id'] as int,
                  page: item['page'] as int,
                  content: item['content'] ?? '',
                  date: item['created_date'] ?? '',
                  onDelete: () => controller.deleteMemo(item['id'] as int),
                  onUpdate: (newContent) =>
                      controller.updateMemoContent(item['id'] as int, newContent),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
