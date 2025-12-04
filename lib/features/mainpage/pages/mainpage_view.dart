import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';
import 'popular_list_page.dart';
import 'trending_list_page.dart';
import '../../book_detail_page/pages/book_detail_page.dart';
import '../../taste_analysis/pages/taste_analysis_view.dart';
import '../../taste_analysis/bindings/taste_analysis_binding.dart';
import '../../notification/pages/notification_page.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';


class MainpageView extends GetView<MainpageController> {
  const MainpageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단 앱바
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Obx(() => Text(
          controller.headerLogo.value,
          style: const TextStyle(
            color: Color(0xFF4DB56C),
            fontSize: 28,
            fontFamily: 'Sedgwick Ave Display', // 기존 방식 유지
            fontWeight: FontWeight.bold,
          ),
        )),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF4DB56C)),
                onPressed: () => Get.to(() => const NotificationPage()),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.bluetooth, color: Color(0xFF4DB56C)),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 1. 인용구 카드 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/book_detail_page', arguments: 10);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1ECD9).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(() => Text(
                        controller.highlightQuote.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF3F3F3F),
                          fontSize: 13,
                          height: 1.6,
                          fontFamily: 'Crimson Text',
                        ),
                      )),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(() => RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 11,
                              fontFamily: 'Roboto',
                            ),
                            children: [
                              TextSpan(text: controller.highlightAuthor.value),
                              const TextSpan(text: ', '),
                              TextSpan(
                                text: '《${controller.highlightBookTitle.value}》',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 2. 카테고리 아이콘 그리드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem('캘린더', Icons.calendar_today, const Color(0xFF4DB56C)),

                  _buildCategoryItem(
                    '취향분석',
                    Icons.bar_chart,
                    const Color(0xFF4DB56C),
                    onTap: () => Get.to(() => const TasteAnalysisView(), binding: TasteAnalysisBinding()),
                  ),

                  _buildCategoryItem(
                    '보관함',
                    Icons.inventory_2_outlined,
                    const Color(0xFF4DB56C),
                    onTap: () => Get.to(() => const BookStorageView(), binding: BookStorageBinding()),
                  ),
                  _buildCategoryItem('추천', Icons.auto_awesome, const Color(0xFF4DB56C)),
                  _buildCategoryItem('그룹', Icons.people_outline, const Color(0xFF4DB56C)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. 인기 순위 헤더
            GestureDetector(
              onTap: () => Get.to(() => const PopularListPage()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '인기 순위',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. 인기 순위 가로 스크롤
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.popularBookList.isEmpty) {
                  return const Center(child: Text("데이터가 없습니다."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final book = controller.popularBookList[index];
                    return _buildBookItem(book);
                  },
                );
              }),
            ),

            const SizedBox(height: 40),

            // 5. 급상승 검색 도서 헤더
            GestureDetector(
              onTap: () => Get.to(() => const TrendingListPage()),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '검색 순위',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 6. 검색 순위 도서 가로 스크롤
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.trendingBookList.isEmpty) {
                  return const Center(child: Text("데이터 로딩 중..."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final book = controller.trendingBookList[index];
                    return _buildBookItem(book);
                  },
                );
              }),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // --- 헬퍼 메서드들 ---

  Widget _buildCategoryItem(String label, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => TempCategoryPage(title: label)),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItem(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/book_detail_page', arguments: book['id']);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 118,
            height: 177,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: const Color(0xFFD4D4D4)),
              borderRadius: BorderRadius.circular(2),
              image: DecorationImage(
                image: NetworkImage(book['imageUrl']),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 118,
            child: Text(
              book['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '평균★${book['rating']}',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class TempCategoryPage extends StatelessWidget {
  final String title;
  const TempCategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              '$title 페이지 준비중입니다.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}