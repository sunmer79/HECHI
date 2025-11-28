import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';

abstract class Routes {
  static const initial = '/';
  static const login = '/login';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => const MainWrapper()),
    GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
  ];
}