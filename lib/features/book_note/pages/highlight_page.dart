import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/book_note_controller.dart';
import '../widgets/highlight_item.dart';
import '../widgets/dialogs/sort_bottom_sheet.dart';

class HighlightPage extends GetView<BookNoteController> {
  const HighlightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 정렬 바
        GestureDetector(
          onTap: () {
            showSortBottomSheet(
              context,
              controller.highlightSort.value,
                  (selected) => controller.updateHighlightSort(selected),
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
                    controller.highlightSort.value == 'date' ? '날짜 순' : '페이지 순',
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
            if (controller.isLoadingHighlights.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.highlights.isEmpty) {
              return const Center(child: Text('하이라이트가 없습니다.'));
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.highlights.length,
              itemBuilder: (context, index) {
                final item = controller.highlights[index];
                return HighlightItem(
                  id: item['id'] as int,
                  page: item['page'] as int,
                  sentence: item['sentence'] ?? '',
                  date: item['created_date'] ?? '',
                  onDelete: () => controller.deleteHighlight(item['id'] as int),
                  onMemo: () => controller.openHighlightMemoEditor(item),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
