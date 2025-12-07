import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';
import '../widgets/my_device_widget.dart';
import '../widgets/current_book_widget.dart';
import '../widgets/recent_book_list_widget.dart';

// 기존에 만드신 SearchHeaderWidget을 import 한다고 가정
// import 'path/to/search_header_widget.dart';

class ReadingRegistrationView extends GetView<ReadingRegistrationController> {
  const ReadingRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 검색바 (기존 코드 사용 가정)
            Container(
              height: 75,
              color: Colors.white,
              alignment: Alignment.center,
              child: const Text("SearchHeaderWidget Area"), // Placeholder
            ),

            // 2. 메인 컨텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSectionTitle("나의 기기"),
                    const SizedBox(height: 12),

                    // 나의 기기 위젯
                    const MyDeviceWidget(),

                    const SizedBox(height: 30),
                    _buildSectionTitle("현재 연결된 도서"),
                    const SizedBox(height: 12),

                    // 현재 연결된 도서 위젯
                    const CurrentBookWidget(),

                    const SizedBox(height: 30),
                    // 최근 연결된 도서 목록 위젯 (타이틀 포함)
                    const RecentBookListWidget(),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF111111),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}