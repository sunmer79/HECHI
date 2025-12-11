import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';

class SortBottomSheet extends StatelessWidget {
  final String type; // bookmark | highlight | memo

  const SortBottomSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _buildContent(controller),
      ),
    );
  }

  // =====================================================
  // 분기: Bookmark / Highlight / Memo
  // =====================================================
  Widget _buildContent(BookNoteController controller) {
    switch (type) {
      case "bookmark":
        return _bookmarkOptions(controller);
      case "highlight":
        return _highlightOptions(controller);
      case "memo":
        return _memoOptions(controller);
      default:
        return const SizedBox.shrink();
    }
  }

  // =====================================================
  // BOOKMARK 정렬 옵션
  // 날짜 순 / 페이지 순
  // =====================================================
  Widget _bookmarkOptions(BookNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text("날짜 순"),
          onTap: () {
            controller.sortTypeBookmark.value = "date";
            controller.sortTextBookmark.value = "날짜 순";
            controller.sortBookmarks();
            Get.back();
          },
        ),
        ListTile(
          title: const Text("페이지 순"),
          onTap: () {
            controller.sortTypeBookmark.value = "page";
            controller.sortTextBookmark.value = "페이지 순";
            controller.sortBookmarks();
            Get.back();
          },
        ),

        const Divider(height: 1),

        _cancelButton()
      ],
    );
  }

  // =====================================================
  // HIGHLIGHT 정렬 옵션
  // 날짜 순 / 페이지 순
  // =====================================================
  Widget _highlightOptions(BookNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text("날짜 순"),
          onTap: () {
            controller.sortTypeHighlight.value = "date";
            controller.sortTextHighlight.value = "날짜 순";
            controller.sortHighlights();
            Get.back();
          },
        ),
        ListTile(
          title: const Text("페이지 순"),
          onTap: () {
            controller.sortTypeHighlight.value = "page";
            controller.sortTextHighlight.value = "페이지 순";
            controller.sortHighlights();
            Get.back();
          },
        ),

        const Divider(height: 1),

        _cancelButton(),
      ],
    );
  }

  // =====================================================
  // MEMO 정렬 옵션
  // 날짜 순만 가능
  // =====================================================
  Widget _memoOptions(BookNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text("날짜 순"),
          onTap: () {
            controller.sortTypeMemo.value = "date";
            controller.sortTextMemo.value = "날짜 순";
            controller.sortMemos();
            Get.back();
          },
        ),

        const Divider(height: 1),

        _cancelButton(),
      ],
    );
  }

  // =====================================================
  // 공통: 취소 버튼
  // =====================================================
  Widget _cancelButton() {
    return ListTile(
      title: const Center(
        child: Text(
          "취소",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
      onTap: () => Get.back(),
    );
  }
}
