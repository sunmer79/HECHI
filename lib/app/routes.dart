import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';

// 로그인 & 회원가입 관련 import
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';
  static const login = '/login';
  static const signUp = '/sign_up'; // ✅ 추가
}

class AppPages {
  static final pages = [
    // 1. 메인 화면 (초기 진입점)
    GetPage(
      name: Routes.initial,
      page: () => const MainWrapper(),
    ),

    // 2. 고객센터
    GetPage(
      name: Routes.customer,
      page: () => CustomerServicePage(),
    ),

    // 3. 로그인 화면
    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBinding()
    ),

    // 4. 회원가입 화면 (✅ 여기가 빠져있어서 문제였습니다!)
    GetPage(
        name: Routes.signUp,
        page: () => const SignUpView(),
        binding: SignUpBinding()
    ),
  ];
}