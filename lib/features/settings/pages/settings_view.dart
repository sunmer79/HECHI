import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          // 1. 내 설정 섹션
          _buildListItem("내 설정"),
          _buildListItem("공개 범위"),
          _buildListItem("알림"),

          const Divider(thickness: 1, height: 30, color: Color(0xFFEEEEEE)),

          // 2. 서비스 설정 섹션
          _buildListItem("서비스 설정"),

          _buildListItem("공지사항"),
          // ✅ 고객센터 연결
          _buildListItem("고객 센터", onTap: controller.goToCustomerService),
          _buildListItem("HECHI 정보"),
          _buildListItem("실험실"),

          const Divider(thickness: 1, height: 30, color: Color(0xFFEEEEEE)),

          // 3. 계정 관리 섹션
          // ✅ 로그아웃 연결
          _buildListItem("로그아웃", onTap: controller.logout),
          _buildListItem("탈퇴하기", onTap: controller.deleteAccount),
        ],
      ),
    );
  }

  // 섹션 제목 위젯 (작은 글씨)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey, // 약간 흐린 색상
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 리스트 아이템 위젯
  Widget _buildListItem(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {}, // 탭 이벤트가 없으면 빈 함수
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400, // Regular weight
              ),
            ),
          ],
        ),
      ),
    );
  }
}