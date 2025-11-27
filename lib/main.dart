import 'package:flutter/material.dart';
import 'package:hechi/app/main_app.dart';
import 'package:get/get.dart';
import 'app/routes.dart';        // 라우트 파일
import 'features/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HECHI App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4DB56C),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      // ⭐ initialRoute + getPages로 라우팅
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      home: null, // ⚠️ GetX 라우트 사용 시 home은 제거!
    );
  }
}
