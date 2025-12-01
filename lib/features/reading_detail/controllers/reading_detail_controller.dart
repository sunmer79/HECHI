import 'package:get/get.dart';

class ReadingDetailController extends GetxController {
  // Book Information
  final bookTitle = '프로젝트 헤일메리'.obs;
  final authorName = '앤디 위어'.obs;
  final translatorName = '강동혁'.obs;
  final category = '소설 · SF'.obs;
  final publishDate = '2021.05.04'.obs;

  final isReading = true.obs;
  final progressPercent = '34%'.obs;
  final readingPeriod = '2025.11.01 ~ 2025.11.08'.obs;
  final timeSpent = '141분'.obs;

  final coverImagePath = "assets/icons/ex_bookdetailcover.png".obs;

  void toggleBookmark() {
    print("Bookmark toggled");
  }
}