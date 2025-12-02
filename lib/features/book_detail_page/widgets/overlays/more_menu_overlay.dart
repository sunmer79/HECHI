import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreMenuOverlay extends StatelessWidget {
  const MoreMenuOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          menuItem("독서 등록", Icons.book),
          menuItem("읽은 날짜 수정", Icons.calendar_month),
          menuItem("캘린더", Icons.event),
          menuItem("관심없어요", Icons.remove_circle_outline),
        ],
      ),
    );
  }

  Widget menuItem(String label, IconData icon) {
    return InkWell(
      onTap: () { print("📌 Book Menu 클릭: $label"); Get.back(); },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFD4D4D4), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Icon(icon, size: 22, color: Color(0xFFDADADA)),
          ],
        ),
      ),
    );
  }
}