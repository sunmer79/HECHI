import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemoCreationOverlay extends StatelessWidget {
  final Function(int page, String content) onSubmit;
  final TextEditingController pageController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  MemoCreationOverlay({super.key, required this.onSubmit});

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
                const Text("메모 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    final page = int.tryParse(pageController.text) ?? 0;
                    onSubmit(page, contentController.text);
                    Get.back();
                  },
                  child: const Text("확인", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 페이지 입력 (메모는 빨간색 계열)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Text("p.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEF5350))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "관련 페이지 (선택)",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 내용 입력
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "작품에 대한 생각을 자유롭게 적어주세요.",
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