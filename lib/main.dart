import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes.dart';

void main() async {
  await GetStorage.init(); // 저장소 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HECHI App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4DB56C),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      // ⭐ 시작: 로그인 화면
      initialRoute: Routes.login,
      getPages: AppPages.pages,
    );
  }
}