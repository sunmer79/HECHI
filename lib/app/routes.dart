import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';
  static const login = '/login';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const MainWrapper(),
    ),
    GetPage(
      name: Routes.customer,
      page: () => CustomerServicePage(),
    ),
    GetPage(
        name: Routes.initial, page: () => const MainWrapper()
    ),
    GetPage(
        name: Routes.login, page: () => const LoginView(), binding: LoginBinding()
    )
  ];
}