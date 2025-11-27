import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/login/bindings/login_binding.dart';
import 'features/login/pages/login_view.dart';
import 'features/sign_up/bindings/sign_up_binding.dart';
import 'features/sign_up/pages/sign_up_view.dart';

// ✅ [추가됨] 비밀번호 찾기 관련 임포트
import 'features/forget_password/bindings/forget_password_binding.dart';
import 'features/forget_password/pages/forget_password_view.dart';

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
        GetPage(
          name: '/sign_up',
          page: () => const SignUpView(),
          binding: SignUpBinding(),
        ),

        // ✅ [추가됨] 3. 비밀번호 찾기 화면
        GetPage(
          name: '/forget_password',
          page: () => const ForgetPasswordView(),
          binding: ForgetPasswordBinding(),
        ),
      ],
    );
  }
}