import 'package:get/get.dart';
import '../controllers/review_detail_controller.dart';

class ReviewDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewDetailController>(() => ReviewDetailController());
  }
}