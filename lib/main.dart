import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes.dart';

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
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white, titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold), iconTheme: IconThemeData(color: Colors.black)),
      ),
      initialRoute: Routes.login, // 시작은 로그인 화면
      getPages: AppPages.pages,
    );
  }
}