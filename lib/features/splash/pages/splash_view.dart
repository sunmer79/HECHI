import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/app_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // 화면 빌드 후 자동 로그인 검사 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(AppController()).checkAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu_book_rounded, size: 80, color: Color(0xFF4DB56C)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Color(0xFF4DB56C)),
            SizedBox(height: 20),
            Text("HECHI 실행 중...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}