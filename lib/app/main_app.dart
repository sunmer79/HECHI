import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/theme.dart';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import 'package:hechi/core/widgets/bottom_bar.dart';

import '../../features/mainpage/pages/mainpage_view.dart';
import '../../features/mainpage/controllers/mainpage_controller.dart';
import '../../features/my_read/pages/my_read_page.dart';

import '../../features/search/pages/search_view.dart';
import '../../features/search/controllers/search_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HECHI',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 하단바 컨트롤러 주입
    Get.put(AppController());

    // 2. 메인페이지 컨트롤러 주입
    Get.put(MainpageController());

    // 3. 검색 페이지 컨트롤러 주입
    Get.put(BookSearchController());

    final controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          // Index 0: 홈
          const MainpageView(),

          // Index 1: 검색
          const SearchView(),

          // Index 2: 독서 등록 (임시)
          _buildPlaceholder("독서 등록 페이지"),

          // Index 3: 리워드 (임시)
          _buildPlaceholder("리워드 페이지"),

          // Index 4: 나의 독서
          const MyReadPage(),
        ],
      )),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      color: Colors.white,
      child: Center(child: Text(text, style: const TextStyle(fontSize: 20, color: Colors.grey))),
    );
  }
}