import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';
import '../pages/profile_edit_view.dart'; // 경로 확인 필요

class ProfileHeader extends StatelessWidget {
  final MyReadController controller;

  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.userProfile;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이미지
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4DB56C), width: 2),
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFA5D6A7),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            // 닉네임
            Text(
              profile['nickname'] ?? 'HECHI',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            const SizedBox(height: 4),

            // 소개글
            Text(
              controller.description.value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // 버튼들
            Row(
              children: [
                Expanded(child: _buildOutlineBtn("프로필 수정", Icons.edit, onTap: () => Get.to(() => const ProfileEditView()))),
                const SizedBox(width: 8),
                Expanded(child: _buildOutlineBtn("공유", Icons.share)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOutlineBtn(String text, IconData icon, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFEEEEEE)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == "공유") ...[
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 4)
          ],
          Text(text, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}