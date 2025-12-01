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

  final RxList<String> recentSearches = <String>[].obs;
  final RxString currentKeyword = ''.obs;
  final SearchRepository _repository = SearchRepository();
  final RxList<Book> searchResults = <Book>[].obs;
  final RxBool isLoading = false.obs;

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

    if (recentSearches.contains(value)) {
      recentSearches.remove(value);
    }
    recentSearches.add(value);

    currentKeyword.value = value;
    searchFocusNode.unfocus();

    currentView.value = SearchState.result;
    isLoading.value = true;
    searchResults.clear();

    try {
      final books = await _repository.searchBooks(value);
      searchResults.assignAll(books);
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

  void deleteOneHistory(int index) {
    recentSearches.removeAt(index);
    if (recentSearches.isEmpty) {
      currentView.value = SearchState.emptyHistory;
    }
  }

  void backToSearch() {
    searchTextController.clear();
    searchResults.clear();
    currentView.value = SearchState.initial;
    loadServerHistory();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}