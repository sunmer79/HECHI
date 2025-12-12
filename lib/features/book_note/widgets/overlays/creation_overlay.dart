import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';
import '../styles/overlay_common.dart';

class CreationOverlay extends StatefulWidget {
  final String type; // bookmark | highlight | memo
  final bool isEdit;

  // 공통
  final int? itemId;

  // bookmark
  final int? page;
  final String? memo;

  // highlight
  final String? sentence;
  final bool? isPublic;

  // memo
  final String? content;

  const CreationOverlay({
    super.key,
    required this.type,
    required this.isEdit,
    this.itemId,
    this.page,
    this.memo,
    this.sentence,
    this.isPublic,
    this.content,
  });

  @override
  State<CreationOverlay> createState() => _CreationOverlayState();
}

class _CreationOverlayState extends State<CreationOverlay> {
  late TextEditingController pageController;
  late TextEditingController memoController;
  late TextEditingController sentenceController;
  late TextEditingController contentController;
  late bool isPublic;

  @override
  void initState() {
    super.initState();

    pageController = TextEditingController(text: widget.page?.toString() ?? "");
    memoController = TextEditingController(text: widget.memo ?? "");
    sentenceController = TextEditingController(text: widget.sentence ?? "");
    contentController = TextEditingController(text: widget.content ?? "");
    isPublic = widget.isPublic ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            /*
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              minHeight: MediaQuery.of(context).size.height * 0.6,
            ),
             */
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: widget.type == "bookmark"
                ? _buildBookmarkLayout(controller)
                : widget.type == "highlight"
                    ? _buildHighlightLayout(controller)
                    : _buildMemoLayout(controller),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // 공통 헤더 (취소 / 제목 / 확인)
  // =========================================================
  Widget _buildHeader(BookNoteController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("취소", style: OverlayCommon.actionStyle),
          ),
          Text(
            _title(),
            style: OverlayCommon.headerStyle,
          ),
          TextButton(
            onPressed: () => _onConfirm(controller),
            child: const Text("확인", style: OverlayCommon.actionStyle),
          ),
        ],
      ),
    );
  }

  String _title() {
    switch (widget.type) {
      case "bookmark":
        return widget.isEdit ? "북마크 수정" : "북마크 작성";
      case "highlight":
        return widget.isEdit ? "하이라이트 수정" : "하이라이트 작성";
      default:
        return widget.isEdit ? "메모 수정" : "메모 작성";
    }
  }

  // =========================================================
  // Bookmark 레이아웃
  // =========================================================
  Widget _buildBookmarkLayout(BookNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --------------------- Header ---------------------
        _buildHeader(controller),

        // --------------------- Divider ---------------------
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFFF3F3F3),
        ),

        // --------------------- 연두색 영역 (페이지 입력) ---------------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          color: const Color(0x80D1EDD9), // 연두색
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "p.",
                style: TextStyle(
                  color: Color(0xFF717171),
                  fontSize: 15,
                  height: 1.67,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: pageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: "북마크할 페이지 번호를 입력해주세요.",
                    hintStyle: TextStyle(
                      color: Color(0xFFABABAB),
                      fontSize: 13,
                      height: 1.9,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 15,
                    height: 1.67,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --------------------- 메모 입력 ---------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          child: TextField(
            controller: memoController,
            maxLines: 10,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "페이지에 대한 생각을 자유롭게 적어주세요.",
              hintStyle: TextStyle(
                color: Color(0xFFABABAB),
                fontSize: 13,
                height: 2.15,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // highlight 레이아웃
  // =========================================================

  Widget _buildHighlightLayout(BookNoteController controller) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // HEADER
            _buildHeader(controller),

            // DIVIDER
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFF3F3F3),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                //padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================
                    // 연두색 문장 입력 박스
                    // ==========================
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0x7FD1ECD9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 페이지 입력
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "p.",
                                style: TextStyle(
                                  color: Color(0xFFABABAB),
                                  fontSize: 15,
                                  height: 1.67,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: pageController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    /*
                                    hintText: "페이지 번호",
                                    hintStyle: TextStyle(
                                      color: Color(0xFFABABAB),
                                      fontSize: 13,
                                      height: 1.9,
                                    ),
                                    */
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF3F3F3F),
                                    fontSize: 15,
                                    height: 1.67,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ==========================
                          // 문장 입력
                          // ==========================
                          TextField(
                            controller: sentenceController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: "하이라이트 문장을 입력하세요.",
                              hintStyle: TextStyle(
                                color: Color(0xFFABABAB),
                                fontSize: 13,
                                height: 1.9,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF3F3F3F),
                              fontSize: 15,
                              height: 1.67,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================
                    // 메모 입력
                    // ==========================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                      child: TextField(
                        controller: memoController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "문장에 대한 생각을 자유롭게 적어주세요.",
                          hintStyle: TextStyle(
                            color: Color(0xFFABABAB),
                            fontSize: 13,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF3F3F3F),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // push content to bottom
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),

            // ==========================
            // 공개 여부
            // ==========================
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("공개 여부",
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  Switch(
                    value: isPublic,
                    onChanged: (v) => setState(() => isPublic = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // memo 레이아웃
  // =========================================================
  Widget _buildMemoLayout(BookNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -----------------------------------------------------
        // Header
        // -----------------------------------------------------
        _buildHeader(controller),

        // Divider line (Figma 위치 동일)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFF3F3F3), width: 1),
              bottom: BorderSide(color: Color(0xFFF3F3F3), width: 1),
            ),
          ),
        ),

        // -----------------------------------------------------
        // 아래 Memo 입력 영역
        // -----------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          child: TextField(
            controller: contentController,
            maxLines: 10,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "작품에 대한 생각을 자유롭게 적어주세요.",
              hintStyle: TextStyle(
                color: Color(0xFFABABAB),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 2.15,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }


  // =========================================================
  // Confirm 버튼 로직
  // =========================================================
  void _onConfirm(BookNoteController controller) {
    switch (widget.type) {
      case "bookmark":
        final page = int.tryParse(pageController.text);
        if (page == null) {
          Get.snackbar("오류", "페이지 번호를 입력해주세요.");
          return;
        }
        final memo = memoController.text.trim();

        if (widget.isEdit) {
          controller.updateBookmark(widget.itemId!, page, memo);
        } else {
          controller.createBookmark(page, memo);
        }
        break;

      case "highlight":
        final sentence = sentenceController.text.trim();
        if (sentence.isEmpty) {
          Get.snackbar("오류", "문장을 입력해주세요.");
          return;
        }
        final memo = memoController.text.trim();

        if (widget.isEdit) {
          controller.updateHighlight(
            widget.itemId!,
            sentence,
            memo,
            isPublic,
          );
        } else {
          controller.createHighlight(sentence, memo, isPublic);
        }
        break;

      case "memo":
        final content = contentController.text.trim();
        if (content.isEmpty) {
          Get.snackbar("오류", "메모를 입력해주세요.");
          return;
        }

        if (widget.isEdit) {
          controller.updateMemo(widget.itemId!, content);
        } else {
          controller.createMemo(content);
        }
        break;
    }
  }

  // =========================================================
  // highlight / memo 입력 필드
  // =========================================================
  Widget _buildInputFields() {
    switch (widget.type) {
      case "highlight":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: sentenceController,
              maxLines: 3,
              decoration: OverlayCommon.input("하이라이트 문장"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: memoController,
              maxLines: 5,
              decoration: OverlayCommon.input("메모 내용"),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("공개 여부", style: TextStyle(fontSize: 14)),
                Switch(
                  value: isPublic,
                  onChanged: (v) => setState(() => isPublic = v),
                )
              ],
            )
          ],
        );

      default: // memo
        return TextField(
          controller: contentController,
          maxLines: 10,
          decoration: OverlayCommon.input("메모 내용을 입력하세요"),
        );
    }
  }
}
