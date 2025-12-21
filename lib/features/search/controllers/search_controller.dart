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
      await _syncReadingStatus(books);
      await loadServerHistory();
    } catch (e) {
      print("에러 발생: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSearch() async {
    if (currentKeyword.value.isNotEmpty) {
      print("🔄 검색 결과 새로고침 중...");
      final books = await _repository.searchBooks(currentKeyword.value);
      searchResults.assignAll(books);
      await _syncReadingStatus(books);
    }
  }

  Future<void> _syncReadingStatus(List<Book> books) async {
    final List<int> myReadingIds = await _repository.getMyReadingBookIds();
    final Set<int> newRegisteredIds = {};

    for (var book in books) {
      if (myReadingIds.contains(book.id)) {
        newRegisteredIds.add(book.id);
      }
    }

    registeredBookIds.assignAll(newRegisteredIds);

    print("🔄 UI 동기화 완료: 체크된 도서 ${registeredBookIds.length}권");
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

  void showRegisterDialog(Book book) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '해당 도서는 도서 보관함 \'읽는 중\'에 포함되고,\n북스토퍼에 등록됩니다.',
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

            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        bool success = await _repository.registerReadingBook(book.id);
                        if (success) {
                          registeredBookIds.add(book.id);
                          Get.back();
                          Get.snackbar(
                            "알림",
                            "'${book.title}' 도서가 등록되었습니다.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(20),
                          );
                        } else {
                          Get.snackbar(
                            "오류",
                            "도서 등록에 실패했습니다. 다시 시도해 주세요.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '예',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50),
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
                        print("📖 '${book.title}' 상세 페이지로 이동");
                        await Get.toNamed('/book_detail_page', arguments: book.id);
                        refreshSearch();
                      },
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                      child: const Center(
                        child: Text(
                          '도서 상세',
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

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}