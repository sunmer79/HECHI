import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

class CommentOverlay extends StatelessWidget {
  final Function(String, bool) onSubmit;   // content + spoiler 함께 전달
  const CommentOverlay({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final RxString text = "".obs;
    final RxBool isSpoiler = false.obs;
    final controller = Get.find<BookDetailController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: Get.height * 0.9,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ===== 헤더 =====
            Row(
              children: [
                TextButton(
                  onPressed: Get.back,
                  child: const Text("취소",
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ),
                const Spacer(),
                const Text("코멘트 작성",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Spacer(),

                TextButton(
                  onPressed: () async {
                    if (text.value.trim().isEmpty) {
                      Get.snackbar("알림", "내용을 입력해주세요");
                      return;
                    }

                    await onSubmit(text.value.trim(), isSpoiler.value);

                    controller.isCommented.value = true;
                    controller.fetchReviews();

                    Get.back();
                    Get.snackbar("완료", "리뷰가 등록되었습니다.");
                  },
                  child: const Text("등록",
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              ],
            ),

            // ===== 내용 입력 =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: TextField(
                  autofocus: true,
                  maxLines: null,
                  onChanged: (v) => text.value = v,
                  decoration: const InputDecoration(
                    hintText: "작품에 대한 생각을 자유롭게 적어주세요",
                    hintStyle:
                    TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // ===== 스포일러 토글 (하단 배치) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 0, 17, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "스포일러",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => Switch(
                    value: isSpoiler.value,
                    onChanged: (v) => isSpoiler.value = v,
                    activeColor: Colors.green,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}