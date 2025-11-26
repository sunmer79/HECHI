import 'package:get/get.dart';

// 여기에 모든 페이지 import
import 'package:hechi/features/home/home_page.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';

// 필요한 페이지 계속 추가

// ⭐ 라우트 경로 모아놓는 클래스
abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';

// 계속 추가
}

// ⭐ AppPages: GetX 라우터 등록
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.customer,
      page: () => CustomerServicePage(),
    ),
  ];
}
