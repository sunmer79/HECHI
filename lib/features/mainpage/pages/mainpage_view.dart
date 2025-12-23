import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';

// 위젯들
import '../widgets/main_app_bar.dart';
import '../widgets/today_highlight.dart';
import '../widgets/category_grid.dart';
import '../widgets/book_list_section.dart';

// 페이지들 (이동용)
import 'popular_list_page.dart';
import 'trending_list_page.dart';
import 'theme_list_page.dart';
// ⭐ [NEW] 새로 만든 페이지 import
import '../pages/bestseller_page.dart';
import '../pages/new_books_page.dart';
import '../pages/genre_bestseller_page.dart';
import '../pages/single_genre_list_page.dart';
// ... imports ...

class MainpageView extends GetView<MainpageController> {
  const MainpageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1️⃣ [Head] 감성 & 기능 영역
            // ==========================================
            const SizedBox(height: 10),
            const TodayHighlight(), // 오늘의 명언/책

            const SizedBox(height: 30),
            const CategoryGrid(),   // 메뉴 아이콘

            const SizedBox(height: 40),

            // ==========================================
            // 2️⃣ [Anchor] 가장 대중적인 지표 (신뢰도)
            // ==========================================
            // 전체 베스트셀러 (가장 기본이 되는 추천)
            Obx(() {
              if (controller.bestsellerList.isEmpty) return const SizedBox();
              return BookListSection(
                title: "베스트셀러",
                bookList: controller.bestsellerList,
                onHeaderTap: () => Get.to(() => const BestsellerPage()),
              );
            }),

            const SizedBox(height: 10),

            // ==========================================
            // 4️⃣ [Social Proof] 평점/리뷰 기반
            // ==========================================
            // 인기 순위 (평점/리뷰가 좋은 책)
            Obx(() {
              if (controller.isLoading.value && controller.popularBookList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.popularBookList.isEmpty) return const SizedBox();

              return BookListSection(
                title: "인기순",
                bookList: controller.popularBookList,
                onHeaderTap: () => Get.to(() => const PopularListPage()),
              );
            }),

            const SizedBox(height: 10),

            // ==========================================
            // 5️⃣ [Discovery] 발견 & 트렌드
            // ==========================================
            // 신간 도서 (새로운 책)
            Obx(() {
              if (controller.newBookList.isEmpty) return const SizedBox();
              return BookListSection(
                title: "신간 도서",
                bookList: controller.newBookList,
                onHeaderTap: () => Get.to(() => const NewBooksPage()),
              );
            }),

            const SizedBox(height: 10),

            // 급상승 검색어 (현재 이슈)
            Obx(() {
              if (controller.trendingBookList.isEmpty) return const SizedBox();
              return BookListSection(
                title: "급상승 검색",
                bookList: controller.trendingBookList,
                onHeaderTap: () => Get.to(() => const TrendingListPage()),
              );
            }),

            const SizedBox(height: 10),

            Obx(() {
              if (controller.genreBestsellerList.isEmpty) return const SizedBox();

              return Column(
                children: controller.genreBestsellerList.map((section) {
                  return Column(
                    children: [
                      BookListSection(
                        title: "${section['title']} 베스트", // 예: 소설 베스트
                        bookList: section['books'],

                        // 💥 [핵심 수정] 전체 장르 페이지가 아니라, '이 장르' 상세 페이지로 이동!
                        onHeaderTap: () {
                          Get.to(
                                () => const SingleGenreListPage(),
                            // 데이터를 짐싸서 보냅니다 (제목, 책 리스트)
                            arguments: {
                              'title': "${section['title']} 베스트",
                              'books': section['books'],
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              );
            }),

            // ==========================================
            // 6️⃣ [Curated] 깊이 있는 추천 (Editorial)
            // ==========================================
            // 테마별 큐레이션 (가장 하단에서 천천히 탐색 유도)
            Obx(() {
              if (controller.curationList.isEmpty) return const SizedBox.shrink();

              return Column(
                children: controller.curationList.map((curation) {
                  return Column(
                    children: [
                      BookListSection(
                        title: '# ${curation['title']}',
                        bookList: curation['books'],
                        onHeaderTap: () {
                          controller.fetchThemeDetail(curation['title']);
                          Get.to(() => const ThemeListPage());
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 10), // 하단 여백
          ],
        ),
      ),
    );
  }
}