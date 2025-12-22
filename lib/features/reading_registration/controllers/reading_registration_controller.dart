import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import '../data/models/reading_library_model.dart';
import '../data/models/reading_registration_session_model.dart';
import '../data/repository/reading_registration_repository.dart';
import '../data/models/reading_book_summary_model.dart';

class ReadingRegistrationController extends GetxController {
  final ReadingRegistrationRepository repository;
  ReadingRegistrationController({required this.repository});

  // State
  var libraryReadingItems = <ReadingLibraryItem>[].obs;
  var isLoading = false.obs;

  // 현재 위젯에 표시되는 책
  var currentActiveBook = Rxn<ReadingLibraryItem>();

  // Active Session (타이머 관련)
  var currentSession = Rxn<ReadingRegistrationSession>();
  var elapsedSeconds = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    refreshData();

    try {
      if (Get.isRegistered<AppController>()) {
        final appController = Get.find<AppController>();
        ever(appController.currentIndex, (index) {
          if (index == 2) {
            refreshData(showLoading: false);
          }
        });
      }
    } catch (e) {
      print("AppController 탭 감지 실패: $e");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> refreshData({bool showLoading = true}) async {
    try {
      if (showLoading && libraryReadingItems.isEmpty) isLoading(true);

      final items = await repository.getLibraryReadingItems();
      libraryReadingItems.assignAll(items);

      if (currentActiveBook.value != null) {
        final updatedBook = items.firstWhereOrNull(
                (item) => item.book.id == currentActiveBook.value!.book.id
        );
        // 독서 중이 아닐 때만 업데이트 (독서 중엔 하드웨어 실시간 데이터가 우선)
        if (currentSession.value == null) {
          currentActiveBook.value = updatedBook ?? (items.isNotEmpty ? items.first : null);
        }
      } else {
        currentActiveBook.value = items.isNotEmpty ? items.first : null;
      }
      if (currentActiveBook.value != null) {
        await loadBookDetail(currentActiveBook.value!.book.id);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      if (showLoading) isLoading(false);
    }
  }

  ReadingLibraryItem? getBookItem(int bookId) {
    try {
      return libraryReadingItems.firstWhere((item) => item.book.id == bookId);
    } catch (e) {
      return null;
    }
  }

  ReadingLibraryItem? getBookInfo(int bookId) => getBookItem(bookId);

  // [수정 1] 도서 변경 다이얼로그 디자인 적용
  void onBookTap(int bookId) async {
    final newItem = getBookItem(bookId);
    if (newItem == null) return;

    if (currentSession.value != null) {
      Get.snackbar("알림", "현재 진행 중인 독서를 종료한 후 변경해주세요.",
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      return;
    }

    if (currentActiveBook.value == null || currentActiveBook.value!.book.id != bookId) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '도서 변경',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F3F3F),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '\'${newItem.book.title}\'(으)로\n변경하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                        child: const Center(
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF888888), // 취소는 회색 처리
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Color(0xFFEEEEEE)),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          currentActiveBook.value = newItem;
                          await loadBookDetail(bookId);
                        },
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: const Center(
                          child: Text(
                            '변경',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4CAF50), // 강조색
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      showStartDialog(newItem);
    }
  }

  Future<void> loadBookDetail(int bookId) async {
    try {
      final summary = await repository.getBookSummary(bookId);

      if (summary != null && currentActiveBook.value?.book.id == bookId) {
        final currentItem = currentActiveBook.value!;

        currentActiveBook.value = ReadingLibraryItem(
          book: currentItem.book,
          status: currentItem.status,
          currentPage: summary.maxEndPage,
          progressPercent: summary.progressPercent,
          myRating: currentItem.myRating,
          totalSessionSeconds: summary.totalSessionSeconds,
        );

        print("책 상세정보 갱신 완료: 총 ${summary.totalSessionSeconds}초 읽음");
      }
    } catch (e) {
      print("책 상세정보 로드 실패: $e");
    }
  }

  // [수정 2] 독서 시작 다이얼로그 디자인 적용
  void showStartDialog(ReadingLibraryItem item) {
    final startPage = item.currentPage == 0 ? 1 : item.currentPage;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '독서 시작',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${item.book.title}\n독서를 시작하시겠습니까?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Color(0xFFEEEEEE)),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        startReadingSession(item.book.id, startPage);
                      },
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '시작',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startReadingSession(int bookId, int? startPage) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      final session = await repository.startSession(bookId, startPage);

      Get.back(); // 로딩 닫기

      currentSession.value = session;
      elapsedSeconds.value = 0;
      _startTimer();

    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar("오류", "독서를 시작할 수 없습니다.");
    }
  }

  // [수정 3] 독서 종료 다이얼로그 (TextField 포함) 디자인 적용
  void showStopDialog() {
    final currentSimulatedPage = currentActiveBook.value?.currentPage ?? 0;
    final pageCtrl = TextEditingController(text: currentSimulatedPage.toString());

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '독서 종료',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // [수정된 정렬 영역]
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Row 수직 중앙 정렬
                children: [
                  // 라벨 텍스트
                  const Padding(
                    padding: EdgeInsets.only(top: 3), // [중요] 박스와 시각적 높이를 맞추기 위한 미세 조정
                    child: Text(
                      "마지막 페이지",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F3F3F),
                        // height: 1.0 제거 -> 폰트 기본 높이 사용
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 입력 박스
                  SizedBox(
                    width: 90,
                    // height를 지정하지 않고 contentPadding으로 높이 조절
                    child: TextField(
                      controller: pageCtrl,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      cursorColor: const Color(0xFF4CAF50),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        // [중요] 상하 패딩으로 높이를 결정하여 텍스트가 정중앙에 오게 함
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '0',
                        hintStyle: const TextStyle(color: Color(0xFFDDDDDD)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '읽은 페이지를 저장하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Color(0xFFEEEEEE)),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        final endPage = int.tryParse(pageCtrl.text);
                        if (endPage != null && endPage > 0) {
                          Get.back();
                          endReading(endPage);
                        } else {
                          Get.snackbar(
                              "확인", "올바른 페이지 번호를 입력해주세요.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black87,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(20)
                          );
                        }
                      },
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> endReading(int endPage) async {
    if (currentSession.value == null) return;

    final int targetBookId = currentSession.value!.bookId;
    final int sessionId = currentSession.value!.id;
    final int finalSeconds = elapsedSeconds.value;

    _timer?.cancel();
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      final sessionResult = await repository.endSession(sessionId, endPage, finalSeconds);
      print("=== 세션 종료 성공: ${sessionResult.totalSeconds}초, ${sessionResult.endPage}p ===");

      try {
        final summary = await repository.getBookSummary(targetBookId);

        if (summary != null && currentActiveBook.value != null) {
          final updatedItem = ReadingLibraryItem(
            book: currentActiveBook.value!.book,
            status: currentActiveBook.value!.status,
            currentPage: summary.maxEndPage,
            progressPercent: summary.progressPercent,
            myRating: currentActiveBook.value!.myRating,
            totalSessionSeconds: summary.totalSessionSeconds,
          );

          currentActiveBook.value = updatedItem;

          final index = libraryReadingItems.indexWhere((item) => item.book.id == targetBookId);
          if (index != -1) {
            libraryReadingItems[index] = updatedItem;
            libraryReadingItems.refresh();
          }
          print("=== 로컬 데이터 동기화 완료: ${summary.progressPercent}% ===");
        }
      } catch (e) {
        print("⚠️ 요약 정보 로드/파싱 실패 (UI 자동 갱신 안됨): $e");
      }

    } catch (e) {
      Get.back();
      Get.snackbar("오류", "저장에 실패했습니다: ${e.toString()}");
      print("세션 종료 요청 실패: $e");
      return;
    }

    if (Get.isDialogOpen ?? false) Get.back();

    currentSession.value = null;
    elapsedSeconds.value = 0;

    Get.snackbar(
        "완료", "독서가 기록되었습니다.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20)
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
    });
  }

  void updateRealTimePage(int newPage) {
    if (currentActiveBook.value != null) {
      final currentItem = currentActiveBook.value!;
      final totalPages = currentItem.book.totalPages;
      final newProgress = (totalPages > 0) ? ((newPage / totalPages) * 100).toInt() : 0;

      currentActiveBook.value = ReadingLibraryItem(
        book: currentItem.book,
        status: currentItem.status,
        currentPage: newPage,
        progressPercent: newProgress,
        myRating: currentItem.myRating,
      );
    }
  }
}