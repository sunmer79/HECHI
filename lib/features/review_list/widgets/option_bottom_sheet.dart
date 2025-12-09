import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_list_controller.dart';

class OptionBottomSheet extends StatelessWidget {

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const OptionBottomSheet({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 30),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 헤더
          Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Color(0xFF4DB56C), fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),

          // 2. 수정 버튼
          _buildOption("수정", () {
            Get.back(); // 시트 닫기
            if (onEdit != null) onEdit!();
          }),

          // 3. 삭제 버튼
          _buildOption("삭제", () {
            Get.back(); // 1. 시트 닫기
            Get.defaultDialog(
              title: "삭제",
              middleText: "정말 삭제하시겠습니까?",
              textConfirm: "삭제",
              textCancel: "취소",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back();
                if (onDelete != null) {
                  onDelete!();
                } else {
                  print("❌ onDelete 함수가 연결되지 않았습니다!"); // 디버깅용 로그
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOption(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.50, color: Color(0xFFABABAB)),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}