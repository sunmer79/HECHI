import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // 저장소

// 라우트 파일 import
import 'app/routes.dart';

void main() async {
  // 1. 저장소 초기화 (가입 정보 저장용)
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HECHI App',

      // 디자인 테마 설정 (팀장님 설정 유지)
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

      // ⭐ 시작 화면을 '로그인'으로 설정
      // (Routes.login이 정의되어 있어야 합니다. 아래 routes.dart 코드 참고)
      initialRoute: Routes.login,

      // 페이지 리스트는 routes.dart에서 관리
      getPages: AppPages.pages,
    );
  }
}