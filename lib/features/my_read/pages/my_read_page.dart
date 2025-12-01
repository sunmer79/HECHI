import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../customer_service/pages/customer_service_page.dart'; // 고객센터 페이지 import

class MyReadPage extends StatelessWidget {
  const MyReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 각 탭마다 AppBar를 가질 수 있도록 Scaffold 사용
      appBar: AppBar(
        title: const Text('나의 독서', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Color(0xFF4DB56C)),
            const SizedBox(height: 20),

            // 고객센터 문의하기 버튼
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Get.to(() => CustomerServicePage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB56C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.support_agent),
                label: const Text('고객센터 문의하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}