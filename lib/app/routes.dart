import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
import '../features/forget_password/bindings/forget_password_binding.dart';
import '../features/forget_password/pages/forget_password_view.dart';
import '../features/preference/bindings/preference_binding.dart';
import '../features/preference/pages/preference_view.dart';
import '../features/search/pages/search_view.dart';
import '../features/search/pages/isbn_scan_view.dart';


// ✅ 추가
import '../features/book_detail_page/bindings/book_detail_binding.dart';
import '../features/book_detail_page/pages/book_detail_page.dart';

abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgetPassword = '/forget_password';
  static const preference = '/preference';
  static const search = '/search';

  static const bookDetailPage = '/book_detail_page'; // ✅ 추가
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => const MainWrapper()),
    GetPage(name: Routes.customer, page: () => CustomerServicePage()),
    GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: Routes.signUp, page: () => const SignUpView(), binding: SignUpBinding()),
    GetPage(name: Routes.forgetPassword, page: () => const ForgetPasswordView(), binding: ForgetPasswordBinding()),
    GetPage(name: Routes.preference, page: () => const PreferenceView(), binding: PreferenceBinding()),

    // ✅ 추가
    GetPage(name: Routes.bookDetailPage, page: () => const BookDetailPage(), binding:BookDetailBinding()),
  ];
}