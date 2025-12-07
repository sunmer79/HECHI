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
          // 1. 앱 설정 섹션
          _buildSectionHeader("앱 설정"),

          // ✅ 알림 설정 (스위치 버튼)
          Obx(() => SwitchListTile(
            title: const Text(
              "알림",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            activeColor: const Color(0xFF4DB56C), // 켜졌을 때 초록색
            value: controller.isNotificationOn.value,
            onChanged: (value) => controller.toggleNotification(value),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          )),

          const Divider(thickness: 1, height: 30, color: Color(0xFFEEEEEE)),

          // 2. 고객 지원 섹션
          _buildSectionHeader("지원"),

          // ✅ 고객 센터
          _buildListItem("고객 센터", onTap: controller.goToCustomerService),

          const Divider(thickness: 1, height: 30, color: Color(0xFFEEEEEE)),

          // 3. 계정 섹션
          _buildSectionHeader("계정"),

          // ✅ 로그아웃
          _buildListItem("로그아웃", onTap: controller.logout),
        ],
      ),
    );
  }

  // 섹션 제목
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 리스트 아이템 (클릭 가능)
  Widget _buildListItem(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // 터치 영역 확보
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), // 화살표 추가
          ],
        ),
      ),
    );
  }
}