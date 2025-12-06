import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_list_controller.dart';

class SortBottomSheet extends GetView<ReviewListController> {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 헤더 (정렬 텍스트 + 취소 버튼)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(17, 20, 17, 15),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Color(0xFFD4D4D4)), // 헤더 구분선 추가
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '정렬',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Color(0xFF4DB56C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // 2. 옵션 리스트
          _buildOption("좋아요 순", "likes"),
          _buildOption("최신 순", "latest"),
        ],
      ),
    );
  }

  Widget _buildOption(String label, String value) {
    return InkWell(
      onTap: () => controller.changeSort(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFD4D4D4))),
        ),
        child: Obx(() {
          final bool isSelected = controller.currentSort.value == value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFF4EB56D), size: 22),
            ],
          );
        }),
      ),
    );
  }
}