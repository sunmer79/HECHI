import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/book_model.dart';
import '../data/search_repository.dart';
import '../pages/isbn_scan_view.dart';

enum SearchState { initial, emptyHistory, hasHistory, result }

class BookSearchController extends GetxController {
  final Rx<SearchState> currentView = SearchState.initial.obs;
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool isTextEmpty = true.obs;

  final RxList<SearchHistoryItem> recentSearches = <SearchHistoryItem>[].obs;
  final RxString currentKeyword = ''.obs;
  final SearchRepository _repository = SearchRepository();
  final RxList<Book> searchResults = <Book>[].obs;
  final RxBool isLoading = false.obs;

  // [추가] 등록된 도서 ID 관리 (체크 표시 변경용)
  // 실제 앱에서는 서버에서 받아와야 하지만, 지금은 로컬에서 관리
  final RxSet<int> registeredBookIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    searchFocusNode.addListener(_onFocusChange);
    searchTextController.addListener(() {
      isTextEmpty.value = searchTextController.text.isEmpty;
    });
    loadServerHistory();
  }

  // ... (loadServerHistory, _onFocusChange, _checkHistoryState 등 기존 코드 유지) ...
  Future<void> loadServerHistory() async {
    final history = await _repository.getSearchHistory();
    recentSearches.assignAll(history);
    if (recentSearches.isEmpty && currentView.value == SearchState.hasHistory) {
      currentView.value = SearchState.emptyHistory;
    }
  }

  void _onFocusChange() {
    if (searchFocusNode.hasFocus && currentView.value != SearchState.result) {
      _checkHistoryState();
    }
  }

  void _checkHistoryState() {
    if (recentSearches.isNotEmpty) {
      currentView.value = SearchState.hasHistory;
    } else {
      currentView.value = SearchState.emptyHistory;
    }
  }

  void navigateToIsbnScan() => Get.to(() => const IsbnScanView());

  void clearSearchText() {
    searchTextController.clear();
    if (currentView.value == SearchState.result) {
      backToSearch();
    } else {
      _checkHistoryState();
    }
  }

  Future<void> onSubmit(String value) async {
    if (value.isEmpty) return;
    recentSearches.removeWhere((item) => item.query == value);
    final tempItem = SearchHistoryItem(id: -1, query: value);
    recentSearches.insert(0, tempItem);

    currentKeyword.value = value;
    searchFocusNode.unfocus();
    currentView.value = SearchState.result;
    isLoading.value = true;
    searchResults.clear();

    try {
      final books = await _repository.searchBooks(value);
      searchResults.assignAll(books);
      await loadServerHistory();

    } catch (e) {
      print("에러 발생: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearAllHistory() async {
    final success = await _repository.deleteAllHistory();
    if (success) {
      recentSearches.clear();
      currentView.value = SearchState.emptyHistory;
    }
  }

  Future<void> deleteOneHistory(int historyId) async {
    final success = await _repository.deleteHistoryItem(historyId);

    if (success) {
      // 로컬 리스트에서도 해당 ID를 가진 항목 삭제
      recentSearches.removeWhere((item) => item.id == historyId);

      if (recentSearches.isEmpty) {
        currentView.value = SearchState.emptyHistory;
      }
    } else {
      Get.snackbar("알림", "삭제에 실패했습니다.");
    }
  }

  void backToSearch() {
    searchTextController.clear();
    searchResults.clear();
    currentView.value = SearchState.initial;
    loadServerHistory();
  }

  // 독서 등록 팝업 띄우기
  void showRegisterDialog(Book book) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '\'${book.title}\'를 등록하시겠습니까?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3F3F),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 설명 텍스트
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '해당 도서는 도서 보관함 \'읽고 있는\'에 포함되고,\n북스토퍼에 등록됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // 버튼 영역
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  // '예' 버튼
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // 1. 등록 처리 (ID 저장)
                        registeredBookIds.add(book.id);
                        Get.back(); // 팝업 닫기

                        // (선택) 하단 스낵바 알림
                        Get.snackbar("알림", "'${book.title}' 도서가 등록되었습니다.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(20));
                      },
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '예',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50), // 초록색 (이미지 참고)
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Color(0xFFEEEEEE)),
                  // '도서 상세' 버튼
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back(); // 팝업 닫기
                        print("📖 상세 페이지 연결 예정");
                        Get.snackbar("알림", "상세 페이지는 준비 중입니다.");
                      },
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '도서 상세',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50), // 초록색
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

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}