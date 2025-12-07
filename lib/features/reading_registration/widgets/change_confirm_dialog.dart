import 'package:flutter/material.dart';

class ChangeConfirmDialog extends StatelessWidget {
  final String currentTitle; // 현재 연결된 책 제목
  final String newTitle;     // 새로 연결할 책 제목
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ChangeConfirmDialog({
    super.key,
    required this.currentTitle,
    required this.newTitle,
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
                const Text(
                  "도서를 변경하시겠습니까?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                // 문구 조합: 현재 도서 -> 새 도서
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      height: 1.5,
                      fontFamily: 'Roboto', // 앱 기본 폰트로 설정하세요
                    ),
                    children: [
                      const TextSpan(text: "현재 연결된 도서\n"),
                      TextSpan(
                        text: "'$currentTitle'",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                      ),
                      const TextSpan(text: " 가 존재하는데,\n"),
                      TextSpan(
                        text: "'$newTitle'",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                      ),
                      const TextSpan(text: " (으)로 변경하시겠습니까?"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // 2. 버튼 영역
          SizedBox(
            height: 55,
            child: Row(
              children: [
                // '예' 버튼
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
                          color: Color(0xFF4CAF50), // 긍정 버튼 색상
                        ),
                      ),
                    ),
                  ),
                ),
                // 구분선
                Container(width: 1, color: const Color(0xFFEEEEEE)),
                // '아니오' 버튼
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
                          color: Color(0xFF333333),
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