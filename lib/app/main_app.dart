import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/theme.dart';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import 'package:hechi/core/widgets/bottom_bar.dart';

// 페이지 임포트
import 'package:hechi/features/home/home_page.dart';

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
    Get.put(AppController());
    final controller = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          const HomePage(),
          _buildPlaceholder("검색"),
          _buildPlaceholder("독서 등록"),
          _buildPlaceholder("리워드"),
          _buildPlaceholder("나의 독서"),
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