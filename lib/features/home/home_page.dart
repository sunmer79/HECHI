import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../notification/pages/notification_page.dart';
import '../customer_service/pages/customer_service_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HECHI 홈'),
        centerTitle: true,
        actions: [
          // 앱바의 알림 아이콘을 눌러도 이동 가능
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Get.to(() => const NotificationPage()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 80, color: Color(0xFF4DB56C)),
            const SizedBox(height: 20),
            const Text(
              '안녕하세요!\n무엇을 도와드릴까요?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            // 1. 알림 페이지 이동 버튼
            _buildMenuButton(
              title: '알림 확인하기',
              icon: Icons.notifications_active_outlined,
              color: Colors.orangeAccent,
              onTap: () => Get.to(() => const NotificationPage()),
            ),

            const SizedBox(height: 20),

            // 2. 고객센터 페이지 이동 버튼
            _buildMenuButton(
              title: '고객센터 문의하기',
              icon: Icons.support_agent,
              color: const Color(0xFF4DB56C),
              onTap: () => Get.to(() => CustomerServicePage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: color, width: 1.5),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        icon: Icon(icon, color: color, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}