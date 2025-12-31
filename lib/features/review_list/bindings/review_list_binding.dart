import 'package:get/get.dart';
import '../controllers/review_list_controller.dart';

class ReviewListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewListController>(() => ReviewListController());
  }
}