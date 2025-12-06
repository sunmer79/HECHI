import 'package:flutter/material.dart';

enum MemoEditorType { bookmark, highlight, memo }

Future<void> showMemoEditorOverlay({
  required BuildContext context,
  required MemoEditorType type,
  String? sentence,       // 하이라이트 문장
  int? page,              // 페이지 번호
  String? initialContent, // 메모 내용
  required Function(int? page, String content) onSubmit,
}) async {
  final TextEditingController contentController =
  TextEditingController(text: initialContent ?? "");
  final TextEditingController pageController =
  TextEditingController(text: page?.toString() ?? "");

  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (_) => StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "취소",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4DB56C),
                            ),
                          ),
                        ),
                        Text(
                          "메모 작성",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onSubmit(
                              type == MemoEditorType.memo
                                  ? null
                                  : int.tryParse(pageController.text),
                              contentController.text,
                            );
                          },
                          child: const Text(
                            "확인",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4DB56C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ============ 조건별 상단 영역 =============
                  if (type == MemoEditorType.bookmark)
                    _buildBookmarkPageField(pageController),

                  if (type == MemoEditorType.highlight)
                    _buildHighlightSentence(sentence!, page),

                  const SizedBox(height: 15),

                  /// CONTENT FIELD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: TextField(
                      controller: contentController,
                      autofocus: true,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "작품에 대한 생각을 자유롭게 적어주세요.",
                        hintStyle: TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    }),
  );
}

/// BOOKMARK - page 입력 필드
Widget _buildBookmarkPageField(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "p. 북마크할 페이지 번호를 입력해주세요.",
          style: TextStyle(fontSize: 13, color: Color(0xFF4DB56C)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "페이지에 대한 생각을 자유롭게 적어주세요.",
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}

/// HIGHLIGHT sentence preview + page
Widget _buildHighlightSentence(String sentence, int? page) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "“$sentence”",
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 6),
        Text(
          "p.$page",
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF4DB56C), height: 1.4),
        ),
      ],
    ),
  );
}
