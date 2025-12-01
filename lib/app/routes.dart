import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';

import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
import '../features/forget_password/bindings/forget_password_binding.dart';
import '../features/forget_password/pages/forget_password_view.dart';

// ✅ 1. 초기 취향 분석 (Preference)
import '../features/preference/bindings/preference_binding.dart';
import '../features/preference/pages/preference_view.dart';

// ✅ 2. 상세 취향 분석 (TasteAnalysis)
import '../features/taste_analysis/bindings/taste_analysis_binding.dart';
import '../features/taste_analysis/pages/taste_analysis_view.dart';

// ✅ 3. 도서 보관함
import '../features/book_storage/pages/book_storage_view.dart';
import '../features/book_storage/bindings/book_storage_binding.dart';

abstract class Routes {
  static const initial = '/';
  static const customer = '/customer';
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgetPassword = '/forget_password';

  // ✅ [복구됨] 초기 취향 선택 (로그인 컨트롤러가 사용)
  static const preference = '/preference';

  // ✅ [추가됨] 상세 취향 분석 (마이페이지에서 이동)
  static const tasteAnalysis = '/taste_analysis';

  static const bookStorage = '/book_storage';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => const MainWrapper()),
    GetPage(name: Routes.customer, page: () => CustomerServicePage()),
    GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: Routes.signUp, page: () => const SignUpView(), binding: SignUpBinding()),
    GetPage(name: Routes.forgetPassword, page: () => const ForgetPasswordView(), binding: ForgetPasswordBinding()),

    // ✅ 1. 초기 취향 선택 페이지 등록
    GetPage(
        name: Routes.preference,
        page: () => const PreferenceView(),
        binding: PreferenceBinding()
    ),

    // ✅ 2. 상세 취향 분석 페이지 등록
    GetPage(
        name: Routes.tasteAnalysis,
        page: () => const TasteAnalysisView(),
        binding: TasteAnalysisBinding()
    ),

    // ✅ 3. 도서 보관함 페이지 등록
    GetPage(
        name: Routes.bookStorage,
        page: () => const BookStorageView(),
        binding: BookStorageBinding()
    ),
  ];
}