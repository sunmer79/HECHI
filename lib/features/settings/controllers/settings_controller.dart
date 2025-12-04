import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hechi/app/routes.dart';

class SettingsController extends GetxController {
  final box = GetStorage();

  // 🚪 로그아웃 로직
  void logout() {
    // 1. 저장된 토큰 및 자동 로그인 설정 삭제
    box.remove('access_token');
    box.remove('refresh_token');
    box.remove('is_auto_login');

    // 2. 로그인 페이지로 이동 (모든 스택 제거)
    Get.offAllNamed(Routes.login);
  }

  // 📞 고객센터 이동
  void goToCustomerService() {
    Get.toNamed(Routes.customer);
  }

  // (추후 구현) 회원 탈퇴 등
  void deleteAccount() {
    // 탈퇴 로직 구현 예정
    Get.snackbar("알림", "탈퇴 기능은 준비 중입니다.");
  }
}