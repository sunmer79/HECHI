import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';

class ReadingRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingRegistrationController>(
          () => ReadingRegistrationController(),
    );
  }
}