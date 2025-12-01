import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../customer_service/pages/customer_service_page.dart';
import '../../reading_detail/pages/reading_detail_view.dart';
import '../../reading_detail/bindings/reading_detail_binding.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';

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

            // 1. 고객센터 문의하기 버튼
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

            // 2. 독서 상세 페이지 이동 버튼
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                        () => const ReadingDetailView(),
                    binding: ReadingDetailBinding(),
                    arguments: 16, // 테스트할 책 ID
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.menu_book),
                label: const Text('독서 상세 페이지'),
              ),
            ),

            const SizedBox(height: 20), // 버튼 사이 간격

            // 3. [추가됨] 도서 보관함 바로가기 버튼
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                        () => const BookStorageView(),
                    binding: BookStorageBinding(), // 컨트롤러 주입을 위해 바인딩 연결 필수
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // 책장 느낌의 갈색
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.library_books),
                label: const Text('도서 보관함'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}