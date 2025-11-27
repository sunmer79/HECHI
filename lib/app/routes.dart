import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
// import 'package:hechi/features/customer_service/pages/customer_service_page.dart'; // 필요하면 주석 해제

// ✅ 로그인 관련 import
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';

abstract class Routes {
  static const initial = '/';
  static const login = '/login'; // 로그인 경로
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const MainWrapper(), // 혹은 LoginView()로 바로 연결해도 됨
    ),
    // ✅ 로그인 페이지 등록
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}