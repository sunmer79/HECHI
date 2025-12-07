import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 텍스트 영역
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
            child: Column(
              children: [
                Text(
                  title, // "정말 삭제하시겠습니까?"
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "삭제하면 해당 도서 독서 상태가 삭제됩니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // 2. 버튼 영역 (Row)
          SizedBox(
            height: 55,
            child: Row(
              children: [
                // 예 버튼
                Expanded(
                  child: InkWell(
                    onTap: onConfirm,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "예",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50), // 사진 속 초록색
                        ),
                      ),
                    ),
                  ),
                ),
                // 세로 구분선
                Container(width: 1, color: const Color(0xFFEEEEEE)),
                // 아니오 버튼
                Expanded(
                  child: InkWell(
                    onTap: onCancel,
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "아니오",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50), // 사진 속 초록색
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}