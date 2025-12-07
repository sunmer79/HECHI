import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkCreationOverlay extends StatelessWidget {
  final Function(int page, String memo) onSubmit;

  final int? initialPage;
  final String? initialMemo;

  late final TextEditingController pageController;
  late final TextEditingController memoController;

  BookmarkCreationOverlay({
    super.key,
    required this.onSubmit,
    this.initialPage,
    this.initialMemo,
  }) {
    pageController = TextEditingController(text: initialPage?.toString() ?? "");
    memoController = TextEditingController(text: initialMemo ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SafeArea(
        child: Column(
          children: [
            // 1. 헤더 (취소 / 제목 / 확인)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text("취소", style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                const Text("북마크 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    final page = int.tryParse(pageController.text) ?? 0;
                    onSubmit(page, memoController.text);
                    Get.back();
                  },
                  child: const Text("확인", style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. 페이지 입력 (녹색 배경 스타일)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // 연한 초록
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text("p.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4DB56C))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "북마크할 페이지 번호를 입력해주세요.",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. 메모 입력
            Expanded(
              child: TextField(
                controller: memoController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "페이지에 대한 생각을 자유롭게 적어주세요.",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}