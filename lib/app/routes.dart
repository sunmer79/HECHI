import 'package:get/get.dart';

// 홈 화면 (경로에 맞게 수정 필요)
import '../features/home/home_page.dart';

// 로그인, 회원가입, 비밀번호 찾기 (우리가 만든 파일들)
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
import '../features/forget_password/bindings/forget_password_binding.dart';
import '../features/forget_password/pages/forget_password_view.dart';

abstract class Routes {
  static const home = '/home';
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgetPassword = '/forget_password';
}

class AppPages {
  static final pages = [
    // 1. 로그인
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    // 2. 회원가입
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    // 3. 비밀번호 찾기
    GetPage(
      name: Routes.forgetPassword,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    // 4. 홈 화면 (로그인 성공 시 이동)
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
  ];
}