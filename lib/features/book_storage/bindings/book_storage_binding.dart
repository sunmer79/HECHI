import 'package:get/get.dart';
import '../controllers/book_storage_controller.dart';
import '../data/book_storage_provider.dart';

class BookStorageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookStorageProvider>(() => BookStorageProvider());
    Get.lazyPut<BookStorageController>(() => BookStorageController(
        provider: Get.find<BookStorageProvider>()
    ));
  }
}