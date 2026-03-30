import 'package:get/get.dart';
import '../controllers/email_verify_controller.dart';

class EmailVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerifyController>(() => EmailVerifyController());
  }
}