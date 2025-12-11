import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';
import '../styles/overlay_common.dart';

class MemoCreationOverlay extends StatefulWidget {
  final bool isEdit;
  final int? memoId;
  final String? initialContent;

  const MemoCreationOverlay({
    super.key,
    required this.isEdit,
    this.memoId,
    this.initialContent,
  });

  @override
  State<MemoCreationOverlay> createState() => _MemoCreationOverlayState();
}

class _MemoCreationOverlayState extends State<MemoCreationOverlay> {
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    contentController =
        TextEditingController(text: widget.initialContent ?? "");
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
                Text(widget.isEdit ? "메모 수정" : "메모 작성",
                    style: OverlayCommon.headerStyle),
                TextButton(
                    onPressed: () {
                      final content = contentController.text.trim();
                      if (content.isEmpty) {
                        Get.snackbar("오류", "메모를 입력해주세요");
                        return;
                      }

                      if (widget.isEdit) {
                        controller.updateMemo(widget.memoId!, content);
                      } else {
                        controller.createMemo(content);
                      }
                    },
                    child: const Text("완료", style: OverlayCommon.actionStyle)),
              ],
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: contentController,
                maxLines: 10,
                decoration:
                OverlayCommon.input("메모 내용을 입력하세요"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}