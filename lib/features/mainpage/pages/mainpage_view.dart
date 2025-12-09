import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/today_highlight.dart';
import '../widgets/category_grid.dart';
import '../widgets/book_list_section.dart';
import 'popular_list_page.dart';
import 'trending_list_page.dart';
import 'theme_list_page.dart';

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
            const SizedBox(height: 10),
            const TodayHighlight(),

            const SizedBox(height: 30),
            const CategoryGrid(),

            const SizedBox(height: 40),

            Obx(() {
              if (controller.isLoading.value) return const CircularProgressIndicator();
              return BookListSection(
                title: "인기 순위",
                bookList: controller.popularBookList,
                onHeaderTap: () => Get.to(() => const PopularListPage()),
              );
            }),

            const SizedBox(height: 40),

            Obx(() {
              if (controller.trendingBookList.isEmpty) {
                return const SizedBox();
              }

              return BookListSection(
                title: "검색 순위",
                bookList: controller.trendingBookList,
                onHeaderTap: () => Get.to(() => const TrendingListPage()),
              );
            }),

            const SizedBox(height: 40),

            Obx(() {
              if (controller.curationList.isEmpty) return const SizedBox.shrink();

              return Column(
                children: controller.curationList.map((curation) {
                  return Column(
                    children: [
                      BookListSection(
                        title: curation['title'],
                        bookList: curation['books'],
                        onHeaderTap: () {
                          controller.fetchThemeDetail(curation['title']);
                          Get.to(() => const ThemeListPage());
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}