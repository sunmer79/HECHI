import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookNoteController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int bookId = Get.arguments ?? 1;

  // =======================
  // Bookmark
  // =======================
  RxBool isLoadingBookmarks = true.obs;
  RxList<Map<String, dynamic>> bookmarks = <Map<String, dynamic>>[].obs;
  RxString bookmarkSort = "date".obs; // 'date' or 'page'

  // =======================
  // Highlight
  // =======================
  RxBool isLoadingHighlights = true.obs;
  RxList<Map<String, dynamic>> highlights = <Map<String, dynamic>>[].obs;
  RxString highlightSort = "date".obs;

  // =======================
  // Memo
  // =======================
  RxBool isLoadingMemos = true.obs;
  RxList<Map<String, dynamic>> memos = <Map<String, dynamic>>[].obs;
  RxString memoSort = "date".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    await Future.wait([
      fetchBookmarks(),
      fetchHighlights(),
      fetchMemos(),
    ]);
  }

  // =======================
  // FETCH BOOKMARKS
  // =======================
  Future<void> fetchBookmarks() async {
    try {
      isLoadingBookmarks.value = true;
      final token = box.read("access_token");

      final res = await http.get(
        Uri.parse("$baseUrl/bookmarks/books/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        bookmarks.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
        _sortBookmarks();
      }
    } catch (e) {
      print("❌ Fetch bookmarks error: $e");
    } finally {
      isLoadingBookmarks.value = false;
    }
  }

  void updateBookmarkSort(String sort) {
    bookmarkSort.value = sort;
    _sortBookmarks();
  }

  void _sortBookmarks() {
    if (bookmarkSort.value == "date") {
      bookmarks.sort((a, b) =>
          (b["created_date"] ?? "").compareTo(a["created_date"] ?? ""));
    } else {
      bookmarks.sort((a, b) =>
          (b["page"] as int).compareTo(a["page"] as int));
    }
    bookmarks.refresh();
  }

  // Delete bookmark
  Future<void> deleteBookmark(int id) async {
    try {
      final token = box.read("access_token");
      final res = await http.delete(
        Uri.parse("$baseUrl/bookmarks/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 204 || res.statusCode == 200) {
        bookmarks.removeWhere((e) => e["id"] == id);
        bookmarks.refresh();
        Get.snackbar("완료", "북마크가 삭제되었습니다.");
      }
    } catch (e) {
      print("❌ Delete bookmark error: $e");
    }
  }

  void openBookmarkMemoEditor(Map item) {
    Get.toNamed("/memo/editor", arguments: item);
  }

  // =======================
  // FETCH HIGHLIGHT
  // =======================
  Future<void> fetchHighlights() async {
    try {
      isLoadingHighlights.value = true;
      final token = box.read("access_token");

      final res = await http.get(
        Uri.parse("$baseUrl/highlights/books/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        highlights.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
        _sortHighlights();
      }
    } catch (e) {
      print("❌ Fetch highlight error: $e");
    } finally {
      isLoadingHighlights.value = false;
    }
  }

  void updateHighlightSort(String sort) {
    highlightSort.value = sort;
    _sortHighlights();
  }

  void _sortHighlights() {
    if (highlightSort.value == "date") {
      highlights.sort((a, b) =>
          (b["created_date"] ?? "").compareTo(a["created_date"] ?? ""));
    } else {
      highlights.sort((a, b) =>
          (b["page"] as int).compareTo(a["page"] as int));
    }
    highlights.refresh();
  }

  Future<void> deleteHighlight(int id) async {
    try {
      final token = box.read("access_token");
      final res = await http.delete(
        Uri.parse("$baseUrl/highlights/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 204 || res.statusCode == 200) {
        highlights.removeWhere((e) => e["id"] == id);
        highlights.refresh();
        Get.snackbar("완료", "하이라이트가 삭제되었습니다.");
      }
    } catch (e) {
      print("❌ Delete highlight error: $e");
    }
  }

  void openHighlightMemoEditor(Map item) {
    Get.toNamed("/memo/editor", arguments: item);
  }

  // =======================
  // FETCH MEMO
  // =======================
  Future<void> fetchMemos() async {
    try {
      isLoadingMemos.value = true;
      final token = box.read("access_token");

      final res = await http.get(
        Uri.parse("$baseUrl/notes/books/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        memos.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
        _sortMemos();
      }
    } catch (e) {
      print("❌ Fetch memo error: $e");
    } finally {
      isLoadingMemos.value = false;
    }
  }

  void updateMemoSort(String sort) {
    memoSort.value = sort;
    _sortMemos();
  }

  void _sortMemos() {
    if (memoSort.value == "date") {
      memos.sort((a, b) =>
          (b["created_date"] ?? "").compareTo(a["created_date"] ?? ""));
    } else {
      memos.sort(
              (a, b) => (b["page"] as int).compareTo(a["page"] as int));
    }
    memos.refresh();
  }

  Future<void> deleteMemo(int id) async {
    try {
      final token = box.read("access_token");
      final res = await http.delete(
        Uri.parse("$baseUrl/notes/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 204 || res.statusCode == 200) {
        memos.removeWhere((e) => e["id"] == id);
        memos.refresh();
        Get.snackbar("완료", "메모가 삭제되었습니다.");
      }
    } catch (e) {
      print("❌ Delete memo error: $e");
    }
  }

  Future<void> updateMemoContent(int id, String newContent) async {
    try {
      final token = box.read("access_token");

      final res = await http.put(
        Uri.parse("$baseUrl/notes/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"content": newContent}),
      );

      if (res.statusCode == 200) {
        final index = memos.indexWhere((e) => e["id"] == id);
        memos[index]["content"] = newContent;
        memos.refresh();
      }
    } catch (e) {
      print("❌ Memo update error: $e");
    }
  }
}
