import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hechi/app/routes.dart';

class SettingsController extends GetxController {
  final box = GetStorage();

  // ✅ 알림 설정 상태 (기본값: true)
  RxBool isNotificationOn = true.obs;

  @override
  void onInit() {
    super.onInit();
    // 저장된 알림 설정 불러오기
    isNotificationOn.value = box.read('is_notification_on') ?? true;
  }

  // 🔔 알림 토글 함수
  void toggleNotification(bool value) {
    isNotificationOn.value = value;
    box.write('is_notification_on', value); // 설정 저장
  }

  // 📞 고객센터 이동
  void goToCustomerService() {
    Get.toNamed(Routes.customer);
  }

  // 🚪 로그아웃
  void logout() {
    box.remove('access_token');
    box.remove('refresh_token');
    box.remove('is_auto_login');

    Get.offAllNamed(Routes.login);
  }
}