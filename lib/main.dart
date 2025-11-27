import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/login/bindings/login_binding.dart';
import 'features/login/pages/login_view.dart';
// import 'features/home/home_page.dart'; // 홈 화면은 일단 주석 처리하거나 필요시 포함

void main() {
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
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
      ],
    );
  }
}