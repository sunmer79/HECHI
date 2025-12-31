import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/book_detail_model.dart';
import '../data/models/reading_session_model.dart';
import '../data/providers/book_provider.dart';
import '../data/providers/reading_provider.dart';
import 'package:get_storage/get_storage.dart';
import '../../reading_registration/controllers/reading_registration_controller.dart';

class ReadingDetailController extends GetxController {
  final BookProvider _bookProvider = BookProvider();
  final ReadingProvider _readingProvider = ReadingProvider();
  final box = GetStorage();

  // [추가] 실시간 데이터 컨트롤러 참조 변수 (nullable로 처리하여 안전성 확보)
  ReadingRegistrationController? _regController;

  final isLoading = true.obs;

  final bookId = 0.obs;
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

    _initLiveSync();

    if (bookId.value > 0) {
      _loadAllData(bookId.value);
    } else {
      isLoading(false);
    }
  }

  // [추가] 실시간 데이터 동기화 설정 메서드
  void _initLiveSync() {
    try {
      // 1. 이미 등록된 ReadingRegistrationController 찾기
      if (Get.isRegistered<ReadingRegistrationController>()) {
        _regController = Get.find<ReadingRegistrationController>();

        // 2. 초기 데이터 즉시 동기화 (API 로딩 전이라도 로컬 데이터가 있으면 우선 표시)
        _syncWithLiveReadingData();

        // 3. 리스트가 변경될 때마다(예: 독서 기록 후) 자동으로 데이터 갱신
        // libraryReadingItems가 변경될 때마다 _syncWithLiveReadingData 실행
        ever(_regController!.libraryReadingItems, (_) {
          _syncWithLiveReadingData();
        });
      }
    } catch (e) {
      print("ReadingRegistrationController를 찾을 수 없습니다: $e");
    }
  }

  // [추가] 로컬 데이터(RegistrationController)와 UI 변수 동기화
  void _syncWithLiveReadingData() {
    if (_regController == null || bookId.value == 0) return;

    // 해당 책이 '내 서재(등록된 책)'에 있는지 확인
    final item = _regController!.getBookItem(bookId.value);

    if (item != null) {
      // 로컬 데이터가 존재하면 API 데이터보다 우선 적용 (실시간성 보장)
      isReading.value = true;
      progressPercent.value = '${item.progressPercent}%';

      // 필요한 경우 총 읽은 시간 등도 업데이트 가능
      timeSpent.value = '${(item.totalSessionSeconds / 60).round()}분';

      print("📘 [Sync] ReadingRegistrationController 데이터로 동기화 완료: ${item.progressPercent}%");
    }
  }

  void _loadAllData(int id) async {
    try {
      isLoading(true);
      await Future.wait([
        fetchBookDetail(id),
        fetchReadingSessions(id),
      ]);

      // [추가] API 로드 후에도 로컬 최신 데이터가 있다면 다시 한 번 덮어씌움 (최신성 유지)
      _syncWithLiveReadingData();

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
    // API에서 세션 기록 가져오기
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
      // API 기록이 없을 때 초기화 (단, _syncWithLiveReadingData가 이후에 덮어쓸 수 있음)
      isReading.value = false;
      progressPercent.value = '0%';
      timeSpent.value = '0분';
      readingPeriod.value = '-';
    }
  }

  void toggleBookmark() {}
}