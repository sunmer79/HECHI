import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionSheet extends StatelessWidget {
  final VoidCallback onDelete;

  final String actionLabel;
  final VoidCallback onAction;

  const OptionSheet({
    super.key,
    required this.onDelete,
    required this.actionLabel,
    required this.onAction,
  });

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
          // 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Text('취소', style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14)),
            ),
          ),

          _buildOption(actionLabel, onAction),

          // 삭제 메뉴
          _buildOption("삭제", () {
            Get.back();
            Get.defaultDialog(
              title: "삭제",
              middleText: "정말 삭제하시겠습니까?",
              textConfirm: "삭제",
              textCancel: "취소",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back();
                onDelete();
              },
            );
          }, isDelete: true),
        ],
      ),
    );
  }

  Widget _buildOption(String label, VoidCallback onTap, {bool isDelete = false}) {
    return InkWell(
      onTap: () {
        Get.back(); // 시트 닫기
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))),
        child: Text(label, style: TextStyle(fontSize: 16, color: isDelete ? Colors.red : Colors.black)),
      ),
    );
  }
}