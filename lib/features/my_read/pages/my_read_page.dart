import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../customer_service/pages/customer_service_page.dart';
import '../../reading_detail/pages/reading_detail_view.dart';
import '../../reading_detail/bindings/reading_detail_binding.dart';

class MyReadPage extends StatelessWidget {
  const MyReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // 1. 고객센터 문의하기 버튼 (기존)
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

            const SizedBox(height: 20), // 버튼 사이 간격

            // 2. [추가됨] 독서 상세 페이지 이동 버튼
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                        () => const ReadingDetailView(),
                    binding: ReadingDetailBinding(),
                    arguments: 16, // 👈 테스트할 책 ID 전달 (예: 16)
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // 구분을 위해 색상 변경
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.menu_book),
                label: const Text('독서 상세 페이지'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}