import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';
import '../data/repository/reading_registration_repository.dart';

class ReadingRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingRegistrationRepository>(() => ReadingRegistrationRepository());

    Get.put(ReadingRegistrationController(repository: Get.find()));
  }
}