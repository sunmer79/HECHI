import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

class SeeAllTasteButton extends StatelessWidget {
  const SeeAllTasteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.tasteAnalysis),
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("모든 취향 분석 보기", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}