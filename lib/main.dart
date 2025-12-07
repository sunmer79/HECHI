import 'package:flutter/material.dart';
import 'package:hechi/app/main_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // ✅ 추가
import 'app/routes.dart';
import 'app/bindings/app_binding.dart';

void main() async {
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

      // ✅ 앱 실행 시 AppBinding 실행 (하단바 컨트롤러 등 준비)
      initialBinding: AppBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}