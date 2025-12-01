import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/theme.dart';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import 'package:hechi/core/widgets/bottom_bar.dart';

// ⬇️ [추가] 실제 연결할 페이지들 import
import '../../features/mainpage/pages/mainpage_view.dart';
import '../../features/mainpage/controllers/mainpage_controller.dart'; // 컨트롤러 import
import '../../features/my_read/pages/my_read_page.dart';


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

    // 2. ⭐ 메인페이지 컨트롤러 주입 (MainpageView가 에러나지 않도록 미리 넣음)
    Get.put(MainpageController());

    final controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      // body 내용이 바뀔 때 애니메이션 없이 바로 전환되도록 IndexedStack 유지
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          // Index 0: 홈 (진짜 메인페이지 연결)
          const MainpageView(),

          // Index 1: 검색 (임시)
          _buildPlaceholder("검색 페이지"),

          // Index 2: 독서 등록 (임시)
          _buildPlaceholder("독서 등록 페이지"),

          // Index 3: 리워드 (임시)
          _buildPlaceholder("리워드 페이지"),

          // Index 4: 나의 독서 (고객센터 버튼 포함됨)
          const MyReadPage(),
        ],
      )),
      // 공통 하단바 (여기서 관리하므로 각 페이지에는 하단바가 없어야 함)
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