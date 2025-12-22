import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class TasteHeader extends GetView<TasteAnalysisController> {
  const TasteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      color: const Color(0xFF4DB56C),
      child: Obx(() {
        final nickname = controller.userProfile['nickname'] ?? 'HECHI';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$nickname's Book", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("취향분석", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                const CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF4DB56C), size: 20)),
                const SizedBox(width: 10),
                Text(nickname, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        );
      }),
    );
  }
}