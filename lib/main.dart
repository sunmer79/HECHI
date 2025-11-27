import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 로그인 관련 임포트
import 'features/login/bindings/login_binding.dart';
import 'features/login/pages/login_view.dart';

// ✅ [추가됨] 회원가입 관련 임포트
import 'features/sign_up/bindings/sign_up_binding.dart';
import 'features/sign_up/pages/sign_up_view.dart';

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

      // 시작은 로그인 화면
      initialRoute: '/login',

      getPages: [
        // 1. 로그인 화면
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),

        // ✅ [추가됨] 2. 회원가입 화면
        GetPage(
          name: '/sign_up',
          page: () => const SignUpView(),
          binding: SignUpBinding(),
        ),
      ],
    );
  }
}