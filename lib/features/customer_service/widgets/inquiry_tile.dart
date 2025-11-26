import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiryTile extends StatelessWidget {
  final String title;
  final String status;
  final String date;

  const InquiryTile({
    Key? key,
    required this.title,
    required this.status,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지 로직 (여기서는 간단한 다이얼로그로 대체하거나 라우팅 추가 가능)
        Get.defaultDialog(
          title: "상세 내용",
          middleText: "$title\n\n상태: $status\n날짜: $date",
          textConfirm: "닫기",
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(),
          buttonColor: const Color(0xFF4DB56C),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: const Color(0xFFABABAB), width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status == '답변완료' ? const Color(0xFF4DB56C) : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == '답변완료' ? Colors.white : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}