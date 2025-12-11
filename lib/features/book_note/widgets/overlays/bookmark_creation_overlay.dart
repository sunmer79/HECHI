import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';
import '../styles/overlay_common.dart';

class BookmarkCreationOverlay extends StatefulWidget {
  final bool isEdit;
  final int? bookmarkId;
  final int? initialPage;
  final String? initialMemo;

  const BookmarkCreationOverlay({
    super.key,
    required this.isEdit,
    this.bookmarkId,
    this.initialPage,
    this.initialMemo,
  });

  @override
  State<BookmarkCreationOverlay> createState() =>
      _BookmarkCreationOverlayState();
}

class _BookmarkCreationOverlayState extends State<BookmarkCreationOverlay> {
  late TextEditingController pageController;
  late TextEditingController memoController;

  @override
  void initState() {
    super.initState();
    pageController =
        TextEditingController(text: widget.initialPage?.toString() ?? "");
    memoController = TextEditingController(text: widget.initialMemo ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ===== Header =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("취소", style: OverlayCommon.actionStyle)),
                Text(widget.isEdit ? "북마크 수정" : "북마크 작성",
                    style: OverlayCommon.headerStyle),
                TextButton(
                    onPressed: () {
                      final page = int.tryParse(pageController.text);
                      if (page == null) {
                        Get.snackbar("오류", "올바른 페이지를 입력해주세요");
                        return;
                      }

                      final memo = memoController.text.trim();

                      if (widget.isEdit) {
                        controller.updateBookmark(
                            widget.bookmarkId!, page, memo);
                      } else {
                        controller.createBookmark(page, memo);
                      }
                    },
                    child: const Text("완료", style: OverlayCommon.actionStyle)),
              ],
            ),

            const Divider(height: 1),

            /// ===== Input Fields =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: pageController,
                    keyboardType: TextInputType.number,
                    decoration:
                    OverlayCommon.input("페이지 번호를 입력하세요 (필수)"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: memoController,
                    maxLines: 5,
                    decoration:
                    OverlayCommon.input("메모를 입력하세요 (선택)"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}