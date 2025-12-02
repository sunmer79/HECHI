import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_detail_controller.dart';

// ✅ 반드시 StatelessWidget을 상속받아야 Widget 타입으로 할당 가능합니다.
class ReadingStatusOverlay extends StatelessWidget {
  final Function(String) onSelect;

  const ReadingStatusOverlay({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 찾기
    final controller = Get.find<BookDetailController>();

    // 내부에서 사용할 타일 위젯
    Widget tile(String label, String status) {
      return InkWell(
        onTap: () => onSelect(status), // 전달받은 함수 실행
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD4D4D4))),
          ),
          child: Obx(() {
            // 현재 선택된 상태인지 확인
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
          // 핸들러 바 (선택 사항)
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