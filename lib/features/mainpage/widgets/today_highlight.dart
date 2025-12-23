import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';

class TodayHighlight extends GetView<MainpageController> {
  const TodayHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: GestureDetector(
        onTap: () {
          print("🖱️ [클릭] 하이라이트 책 ID: ${controller.highlightBookId.value}");
          Get.toNamed('/book_detail_page', arguments: controller.highlightBookId.value);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: const Color(0xFFD1ECD9).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Obx(() => Text(
                controller.highlightQuote.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3F3F3F),
                  fontSize: 13,
                  height: 1.6,
                  fontFamily: 'Crimson Text',
                ),
              )),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() => RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 11,
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      TextSpan(text: controller.highlightAuthor.value),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: '《${controller.highlightBookTitle.value}》',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}