import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';

class SortBottomSheet extends GetView<BookNoteController> {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text("정렬", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(onTap: () => Get.back(), child: const Text("취소", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14))),
              ],
            ),
          ),
          _buildOption("날짜 순", "date"),
          _buildOption("페이지 순", "page"),
        ],
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    return InkWell(
      onTap: () => controller.changeSort(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Obx(() {
          final isSelected = controller.currentSort.value == value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 15)),
              if (isSelected) const Icon(Icons.check, color: Color(0xFF4DB56C), size: 20),
            ],
          );
        }),
      ),
    );
  }
}