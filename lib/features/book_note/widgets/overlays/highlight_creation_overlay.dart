import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';
import '../styles/overlay_common.dart';

class HighlightCreationOverlay extends StatefulWidget {
  final bool isEdit;
  final int? highlightId;
  final String? initialSentence;
  final String? initialMemo;
  final bool? initialPublic;

  const HighlightCreationOverlay({
    super.key,
    required this.isEdit,
    this.highlightId,
    this.initialSentence,
    this.initialMemo,
    this.initialPublic,
  });

  @override
  State<HighlightCreationOverlay> createState() =>
      _HighlightCreationOverlayState();
}

class _HighlightCreationOverlayState extends State<HighlightCreationOverlay> {
  late TextEditingController sentenceController;
  late TextEditingController memoController;
  late bool isPublic;

  @override
  void initState() {
    super.initState();
    sentenceController =
        TextEditingController(text: widget.initialSentence ?? "");
    memoController = TextEditingController(text: widget.initialMemo ?? "");
    isPublic = widget.initialPublic ?? false;
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
                Text(widget.isEdit ? "하이라이트 수정" : "하이라이트 작성",
                    style: OverlayCommon.headerStyle),
                TextButton(
                    onPressed: () {
                      final sentence = sentenceController.text.trim();
                      if (sentence.isEmpty) {
                        Get.snackbar("오류", "문장을 입력해주세요");
                        return;
                      }

                      final memo = memoController.text.trim();

                      if (widget.isEdit) {
                        controller.updateHighlight(
                            widget.highlightId!,
                            sentence,
                            memo,
                            isPublic);
                      } else {
                        controller.createHighlight(
                            sentence, memo, isPublic);
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
                    controller: sentenceController,
                    maxLines: 3,
                    decoration:
                    OverlayCommon.input("하이라이트 문장을 입력하세요 (필수)"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: memoController,
                    maxLines: 5,
                    decoration:
                    OverlayCommon.input("메모를 입력하세요 (선택)"),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("공개 여부 (isPublic)",
                          style: TextStyle(fontSize: 14)),
                      Switch(
                        value: isPublic,
                        onChanged: (v) => setState(() => isPublic = v),
                      ),
                    ],
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