import 'package:get/get.dart';
import 'package:hechi/app/main_app.dart';
import 'package:hechi/features/customer_service/pages/customer_service_page.dart';
import 'package:hechi/app/bindings/app_binding.dart';
import '../features/login/bindings/login_binding.dart';
import '../features/login/pages/login_view.dart';
import '../features/sign_up/bindings/sign_up_binding.dart';
import '../features/sign_up/pages/sign_up_view.dart';
import '../features/forget_password/bindings/forget_password_binding.dart';
import '../features/forget_password/pages/forget_password_view.dart';

import '../features/preference/bindings/preference_binding.dart';
import '../features/preference/pages/preference_view.dart';
import '../features/taste_analysis/bindings/taste_analysis_binding.dart';
import '../features/taste_analysis/pages/taste_analysis_view.dart';

import '../features/search/pages/search_view.dart';
import '../features/search/pages/isbn_scan_view.dart';
import '../features/book_detail_page/bindings/book_detail_binding.dart';
import '../features/book_detail_page/pages/book_detail_page.dart';
import '../features/reading_detail/bindings/reading_detail_binding.dart';
import '../features/reading_detail/pages/reading_detail_view.dart';
import '../features/book_storage/pages/book_storage_view.dart';
import '../features/book_storage/bindings/book_storage_binding.dart';

import '../features/splash/pages/splash_view.dart';
import '../features/settings/pages/settings_view.dart';
import '../features/settings/bindings/settings_binding.dart';


import '../features/review_list/bindings/review_list_binding.dart';
import '../features/review_list/pages/review_list_page.dart';
import '../features/review_detail/bindings/review_detail_binding.dart';
import '../features/review_detail/pages/review_detail_page.dart';

import '../features/calendar/pages/calendar_view.dart';
import '../features/calendar/bindings/calendar_binding.dart';


abstract class Routes {
  static const splash = '/splash';
  static const initial = '/';
  static const customer = '/customer';
  static const login = '/login';
  static const signUp = '/sign_up';
  static const forgetPassword = '/forget_password';
  static const settings = '/settings';
  static const preference = '/preference';

  static const search = '/search';
  static const isbnScan = '/isbn_scan';
  static const bookDetailPage = '/book_detail_page';
  static const readingDetail = '/reading_detail';

  static const tasteAnalysis = '/taste_analysis';

  static const bookStorage = '/book_storage';

  static const reviewList = '/review/list';
  static const reviewDetail = '/review_detail';

  static const calendar = '/calendar';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(name: Routes.initial, page: () => const MainWrapper(), binding:AppBinding()),
    GetPage(name: Routes.customer, page: () => CustomerServicePage()),

    GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: Routes.signUp, page: () => const SignUpView(), binding: SignUpBinding()),
    GetPage(name: Routes.forgetPassword, page: () => const ForgetPasswordView(), binding: ForgetPasswordBinding()),

    GetPage(name: Routes.preference, page: () => const PreferenceView(), binding: PreferenceBinding()),
    GetPage(name: Routes.search, page: () => const SearchView()),
    GetPage(name: Routes.isbnScan, page: () => const IsbnScanView()),
    GetPage(name: Routes.bookDetailPage, page: () => const BookDetailPage(), binding: BookDetailBinding()),
    GetPage(name: Routes.readingDetail, page: () => const ReadingDetailView(), binding: ReadingDetailBinding()),

    GetPage(name: Routes.tasteAnalysis, page: () => const TasteAnalysisView(), binding: TasteAnalysisBinding()),
    GetPage(name: Routes.settings, page: () => const SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.bookStorage, page: () => const BookStorageView(), binding: BookStorageBinding()),
    GetPage(name: Routes.reviewList, page: () => const ReviewListPage(), binding: ReviewListBinding()),
    GetPage(name: Routes.reviewDetail, page: () => const ReviewDetailPage(), binding: ReviewDetailBinding()),
    GetPage(name: Routes.calendar, page: () => const CalendarView(), binding: CalendarBinding()),
  ];
}