import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';

abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';
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
  ];
}