import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

class ReadingStatusOverlay extends StatelessWidget {
  final Function(String) onSelect;

  const ReadingStatusOverlay({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookDetailController>();

    // 내부에서 사용할 타일 위젯
    Widget tile(String label, String status) {
      return InkWell(
        onTap: () {
          final current = controller.readingStatus.value;
          // 🔥 이미 선택된 상태를 한 번 더 누르면 PENDING 으로 해제
          final String nextStatus = (current == status) ? "PENDING" : status;

          onSelect(
              nextStatus); // controller.updateReadingStatus(nextStatus) 호출됨
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD4D4D4))),
          ),
          child: Obx(() {
            final bool isSelected = controller.readingStatus.value == status;
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          tile("읽는 중", "READING"),
          tile("완독함", "COMPLETED"),
        ],
      ),
    );
  }
}