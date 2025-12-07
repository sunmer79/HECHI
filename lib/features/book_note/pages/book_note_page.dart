import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_note_controller.dart';
import '../widgets/book_info_header.dart';
import 'bookmark_tab.dart';
import 'highlight_tab.dart';
import 'memo_tab.dart';

class BookNotePage extends GetView<BookNoteController> {
  const BookNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 2. 책 정보 헤더 (제목, 작가, 표지)
          const BookInfoHeader(),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // 3. 탭 바 (북마크 / 하이라이트 / 메모)
          TabBar(
            controller: controller.tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "북마크"),
              Tab(text: "하이라이트"),
              Tab(text: "메모"),
            ],
          ),

          // 4. 탭 뷰 (각 탭 화면 연결)
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
                BookmarkTab(),
                HighlightTab(),
                MemoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}