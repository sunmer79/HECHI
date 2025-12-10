import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../../features/mainpage/controllers/mainpage_controller.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/my_read/controllers/my_read_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(MainpageController());
    Get.put(BookSearchController());
    Get.put(MyReadController());
  }
}