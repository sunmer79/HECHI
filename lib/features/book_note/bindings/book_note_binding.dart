import 'package:get/get.dart';
import '../controllers/book_note_controller.dart';

class BookNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookNoteController>(() => BookNoteController());
  }
}
