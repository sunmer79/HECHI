import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class TasteAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasteAnalysisController>(() => TasteAnalysisController());
  }
}