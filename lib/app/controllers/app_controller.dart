import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex(index);
  }
}