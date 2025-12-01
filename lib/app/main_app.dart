import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/theme.dart';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import 'package:hechi/core/widgets/bottom_bar.dart';

// 실제 연결할 페이지들 import
import '../features/mainpage/pages/mainpage_view.dart';
import '../features/mainpage/controllers/mainpage_controller.dart';
import '../features/my_read/pages/my_read_page.dart';

import '../features/search/pages/search_view.dart';
import '../features/search/controllers/search_controller.dart';

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

// ✅ StatelessWidget -> GetView<AppController>로 변경
class MainWrapper extends GetView<AppController> {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 하단바 컨트롤러는 main.dart에서 initialBinding으로 넣었으면 생략 가능하지만,
    // 안전을 위해 없으면 넣도록 유지하거나, main.dart 설정에 따라 제거 가능.
    // 여기서는 확실한 동작을 위해 유지합니다.
    if (!Get.isRegistered<AppController>()) {
      Get.put(AppController());
    }

    // 2. 메인페이지 컨트롤러 주입 (MainpageView 에러 방지)
    if (!Get.isRegistered<MainpageController>()) {
      Get.put(MainpageController());
    }

    // 3. 검색 컨트롤러 주입
    if (!Get.isRegistered<BookSearchController>()) {
      Get.put(BookSearchController());
    }

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ [핵심 수정 1] 키보드 올라와도 화면 찌그러짐 방지
      resizeToAvoidBottomInset: false,

      // ✅ [핵심 수정 2] 상하단 안전 영역 확보 (SafeArea)
      body: SafeArea(
        child: Obx(() => IndexedStack(
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

            // Index 4: 나의 독서 (고객센터 버튼 포함됨)
            const MyReadPage(),
          ],
        )),
      ),

      // 공통 하단바
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}