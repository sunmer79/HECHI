import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../notification/pages/notification_page.dart';
import '../customer_service/pages/customer_service_page.dart';
import '../../features/reading_detail/pages/reading_detail_view.dart';
import '../../features/reading_detail/bindings/reading_detail_binding.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HECHI 홈'),
        centerTitle: true,
        actions: [
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

            _buildMenuButton(
              title: '알림 확인하기',
              icon: Icons.notifications_active_outlined,
              color: Colors.orangeAccent,
              onTap: () => Get.to(() => const NotificationPage()),
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              title: '고객센터 문의하기',
              icon: Icons.support_agent,
              color: const Color(0xFF4DB56C),
              onTap: () => Get.to(() => CustomerServicePage()),
            ),

            const SizedBox(height: 40),

            _buildMenuButton(
              title: '[DEV] 팀원 페이지 이동',
              icon: Icons.developer_mode,
              color: Colors.blueAccent,
              onTap: () => Get.to(() => const DevMenuPage()),
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              title: '독서 상세 페이지',
              icon: Icons.menu_book,
              color: Colors.purple,
              onTap: () => Get.to(
                    () => const ReadingDetailView(),
                binding: ReadingDetailBinding(),
              ),
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
      width: 260,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
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

class DevMenuPage extends StatelessWidget {
  const DevMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DEV 메뉴')),
      body: ListView(
        children: [
          _devTile('샘플 페이지', () {}),
        ],
      ),
    );
  }

  ListTile _devTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}