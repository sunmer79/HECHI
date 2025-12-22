import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/book_detail_model.dart';
import '../data/models/reading_session_model.dart';
import '../data/providers/book_provider.dart';
import '../data/providers/reading_provider.dart';
import 'package:get_storage/get_storage.dart';

class ReadingDetailController extends GetxController {
  final BookProvider _bookProvider = BookProvider();
  final ReadingProvider _readingProvider = ReadingProvider();
  final box = GetStorage();

  final isLoading = true.obs;

  final bookId = 0.obs; // 이 라인이 반드시 있어야 합니다.
  final bookTitle = ''.obs;
  final authorName = ''.obs;
  final translatorName = ''.obs;
  final category = ''.obs;
  final publishDate = ''.obs;
  final coverImageUrl = ''.obs;

  final isReading = false.obs;
  final progressPercent = '0%'.obs;
  final readingPeriod = '-'.obs;
  final timeSpent = '0분'.obs;

  int _totalPages = 0;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;

    if (arguments != null && arguments is Map && arguments.containsKey('bookId')) {
      final dynamic receivedId = arguments['bookId'];
      if (receivedId is int) {
        bookId.value = receivedId;
      } else if (receivedId is num) {
        bookId.value = receivedId.toInt();
      }
    }

    if (bookId.value > 0) {
      _loadAllData(bookId.value);
    } else {
      isLoading(false);
    }
  }

  void _loadAllData(int id) async {
    try {
      isLoading(true);
      await Future.wait([
        fetchBookDetail(id),
        fetchReadingSessions(id),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBookDetail(int id) async {
    BookDetailModel? book = await _bookProvider.getBookDetail(id);
    if (book != null) {
      bookTitle.value = book.title;
      authorName.value = book.authors.isNotEmpty ? book.authors.join(', ') : '저자 미상';
      category.value = book.category;
      publishDate.value = book.publishedDate;
      _totalPages = book.totalPages;
      if (book.thumbnail != null && book.thumbnail!.isNotEmpty) {
        coverImageUrl.value = book.thumbnail!;
      }
      translatorName.value = book.publisher;
    }
  }

  Future<void> fetchReadingSessions(int id) async {
    List<ReadingSessionModel> mySessions = await _readingProvider.getSessions(id);
    if (mySessions.isNotEmpty) {
      isReading.value = true;
      int totalSec = mySessions.fold(0, (sum, item) => sum + item.totalSeconds);
      timeSpent.value = '${(totalSec / 60).round()}분';
      int lastReadPage = mySessions.last.endPage;
      if (_totalPages > 0) {
        int percent = ((lastReadPage / _totalPages) * 100).round();
        progressPercent.value = '$percent%';
      }
      DateTime start = DateTime.parse(mySessions.first.startTime);
      DateTime end = DateTime.parse(mySessions.last.endTime);
      DateFormat formatter = DateFormat('yyyy.MM.dd');
      readingPeriod.value = '${formatter.format(start)} ~ ${formatter.format(end)}';
    } else {
      isReading.value = false;
      progressPercent.value = '0%';
      timeSpent.value = '0분';
      readingPeriod.value = '-';
    }
  }

  void toggleBookmark() {}
}