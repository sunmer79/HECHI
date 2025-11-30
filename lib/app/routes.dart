import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';

// 1. 로그인
import '../features/forget_password/bindings/forget_password_binding.dart';
import '../features/forget_password/pages/forget_password_view.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';

// 2. 회원가입
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';

// 3. 비밀번호 찾기


abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';

  // 추가된 경로들
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgetPassword = '/forget_password';
}

class AppPages {
  static final pages = [
    // 메인
    GetPage(
      name: Routes.initial,
      page: () => const MainWrapper(),
    ),

    // 고객센터
    GetPage(
      name: Routes.customer,
      page: () => CustomerServicePage(),
    ),

    // 로그인
    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBinding()
    ),

    // 회원가입
    GetPage(
        name: Routes.signUp,
        page: () => const SignUpView(),
        binding: SignUpBinding()
    ),

    // 비밀번호 찾기
    GetPage(
        name: Routes.forgetPassword,
        page: () => const ForgetPasswordView(),
        binding: ForgetPasswordBinding()
    ),
  ];
}