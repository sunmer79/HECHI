import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

class CommentOverlay extends StatelessWidget {
  final Function(String) onSubmit;
  const CommentOverlay({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookDetailController>();
    final RxString text = "".obs;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom, // 키보드 대응
      ),
      child: SizedBox(
        height: Get.height * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Row(
              children: [
                TextButton(onPressed: () => Get.back(), child: const Text("취소",  style: TextStyle(fontSize: 13, color: Colors.black))),
                const Spacer(),
                const Text("코멘트 작성", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () => controller.submitComment(text.value),
                  child: const Text("등록", style: TextStyle(fontSize: 13, color: Colors.black)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
              child: TextField(
                autofocus: true,
                maxLines: null,
                onChanged: (v) => text.value = v,
                decoration: const InputDecoration(
                    hintText: "작품에 대한 생각을 자유롭게 적어주세요",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400,),
                    border: InputBorder.none
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
