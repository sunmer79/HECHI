import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/controllers/app_controller.dart';
import '../data/models/reading_library_model.dart';
import '../data/models/reading_registration_session_model.dart';
import '../data/repository/reading_registration_repository.dart';

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
        currentActiveBook.value = updatedBook ?? (items.isNotEmpty ? items.first : null);
      } else {
        currentActiveBook.value = items.isNotEmpty ? items.first : null;
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

  void onBookTap(int bookId) {
    final newItem = getBookItem(bookId);
    if (newItem == null) return;

    if (currentSession.value != null) {
      Get.snackbar("알림", "현재 진행 중인 독서를 종료한 후 변경해주세요.",
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      return;
    }

    if (currentActiveBook.value == null || currentActiveBook.value!.book.id != bookId) {
      Get.defaultDialog(
        title: "도서 변경",
        middleText: "'${newItem.book.title}'(으)로 변경하시겠습니까?",
        textConfirm: "변경",
        textCancel: "취소",
        confirmTextColor: Colors.white,
        buttonColor: Colors.black,
        onConfirm: () {
          Get.back();
          currentActiveBook.value = newItem;
        },
      );
    } else {
      showStartDialog(newItem);
    }
  }

  void showStartDialog(ReadingLibraryItem item) {
    final startPage = item.currentPage == 0 ? 1 : item.currentPage;

    Get.defaultDialog(
      title: "독서 시작",
      middleText: "${item.book.title}\n독서를 시작하시겠습니까?",
      textConfirm: "시작",
      textCancel: "취소",
      confirmTextColor: Colors.white,
      buttonColor: Colors.black,
      onConfirm: () {
        Get.back();
        startReadingSession(item.book.id, startPage);
      },
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

  void showStopDialog() {
    final pageCtrl = TextEditingController();
    Get.defaultDialog(
        title: "독서 종료",
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: pageCtrl,
            decoration: const InputDecoration(
              labelText: "마지막 페이지 입력",
              border: OutlineInputBorder(),
              hintText: '숫자만 입력',
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ),
        textConfirm: "저장",
        textCancel: "취소",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () {
          final endPage = int.tryParse(pageCtrl.text);
          if (endPage != null && endPage > 0) {
            Get.back();
            endReading(endPage);
          } else {
            Get.snackbar("확인", "올바른 페이지 번호를 입력해주세요.");
          }
        }
    );
  }

  Future<void> endReading(int endPage) async {
    if (currentSession.value == null) return;
    try {
      _timer?.cancel();
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      // 낙관적 업데이트 (UI 즉시 반영)
      if (currentActiveBook.value != null) {
        final currentItem = currentActiveBook.value!;
        final totalPages = currentItem.book.totalPages;
        final newProgress = (totalPages > 0) ? ((endPage / totalPages) * 100).toInt() : 0;

        final updatedItem = ReadingLibraryItem(
          book: currentItem.book,
          status: currentItem.status,
          currentPage: endPage,
          progressPercent: newProgress,
          myRating: currentItem.myRating,
        );
        currentActiveBook.value = updatedItem;
      }

      await repository.endSession(currentSession.value!.id, endPage, elapsedSeconds.value);

      Get.back(); // 로딩 닫기

      currentSession.value = null;
      elapsedSeconds.value = 0;

      Get.snackbar("완료", "독서가 기록되었습니다.");
      await refreshData(showLoading: false);

    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar("오류", "저장에 실패했습니다.");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;
    });
  }
}