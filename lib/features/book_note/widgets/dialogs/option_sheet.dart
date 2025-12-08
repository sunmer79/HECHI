import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionSheet extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final String editLabel;

  final String actionLabel;
  final VoidCallback onAction;

  const OptionSheet({
    super.key,
    required this.onDelete,
    required this.onEdit,
    this.editLabel = "수정", // "메모 작성", "메모 수정" 등 상황에 맞게 변경 가능
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Text('취소', style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14)),
            ),
          ),

          // 수정 (또는 작성) 버튼
          InkWell(
            onTap: () {
              Get.back(); // 시트 닫고
              onEdit();   // 수정 화면 열기
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
              ),
              child: Text(editLabel, style: const TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),

          // 삭제 버튼
          InkWell(
            onTap: () {
              Get.back();
              // 삭제 재확인 다이얼로그
              Get.defaultDialog(
                title: "삭제",
                middleText: "정말 삭제하시겠습니까?",
                textConfirm: "삭제",
                textCancel: "취소",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back(); // 다이얼로그 닫기
                  onDelete(); // 실제 삭제 로직 실행
                },
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: const Text("삭제", style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}