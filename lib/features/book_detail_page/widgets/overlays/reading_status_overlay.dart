import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

class ReadingStatusOverlay extends StatelessWidget {
  final Function(String) onSelect;
  const ReadingStatusOverlay({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookDetailController>();

    Widget tile(String label, String status) {
      return InkWell(
        onTap: () => controller.updateReadingStatus(status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD4D4D4))),
          ),
          child: Obx(() {
            bool isSelected = controller.readingStatus.value == status;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 16)),
                if (isSelected)
                  const Icon(Icons.check, color: Color(0xFF4EB56D), size: 22),
              ],
            );
          }),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          tile("읽는 중", "reading"),
          tile("완독함", "finished"),
        ],
      ),
    );
  }
}
