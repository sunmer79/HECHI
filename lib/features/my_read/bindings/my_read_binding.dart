import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';

class MyReadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyReadController>(() => MyReadController());
  }
}