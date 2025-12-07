import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HighlightCreationOverlay extends StatelessWidget {
  final Function(int page, String sentence, String memo, bool isShared) onSubmit;

  final int? initialPage;
  final String? initialSentence;
  final String? initialMemo;
  final bool? initalIsShared;

  late final TextEditingController pageController;
  late final TextEditingController sentenceController;
  late final TextEditingController memoController;

  const HighlightCreationOverlay({
    super.key,
    required this.onSubmit,
    this.initialPage,
    this.initialSentence,
    this.initialMemo,
  }) {
    pageController = TextEditingController(text: initialPage?.toString() ?? "");
    sentenceController = TextEditingController(text: initialSentence ?? "");
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
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => Get.back(), child: const Text("취소", style: TextStyle(fontSize: 16))),
                const Text("하이라이트 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    final page = int.tryParse(pageController.text) ?? 0;
                    onSubmit(page, sentenceController.text, memoController.text);
                    Get.back();
                  },
                  child: const Text("확인", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 페이지 입력
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFFFFF9C4), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Text("p.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBC02D))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "페이지 번호",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 문장 입력
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: TextField(
                controller: sentenceController,
                maxLines: 3, // 문장은 적당히 길게
                decoration: const InputDecoration(
                  hintText: "기억하고 싶은 문장을 입력해주세요.",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),

            //  메모 입력
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: memoController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: "문장에 대한 생각을 자유롭게 적어주세요. (선택)",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}