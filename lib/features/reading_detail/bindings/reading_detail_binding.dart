import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';

class ReadingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingDetailController>(() => ReadingDetailController());
  }
}