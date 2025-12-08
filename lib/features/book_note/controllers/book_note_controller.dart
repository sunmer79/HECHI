import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookNoteController extends GetxController with GetSingleTickerProviderStateMixin {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  late final int bookId;
  late final int initialTabIndex;

  // 데이터 리스트
  final RxMap<String, dynamic> bookInfo = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> bookmarks = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> highlights = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> memos = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;

  // 탭 & 정렬
  late TabController tabController;
  final RxInt currentTabIndex = 0.obs;
  final RxString currentSort = "date".obs; // date(날짜순), page(페이지순)
  String get sortText => currentSort.value == "date" ? "날짜 순" : "페이지 순";

  @override
  void onInit() {
    super.onInit();

    // Argument 파싱
    final args = Get.arguments;
    if (args is Map) {
      bookId = args['bookId'] ?? 1;
      initialTabIndex = args['tabIndex'] ?? 0;
    } else {
      bookId = (args is int) ? args : 1;
      initialTabIndex = 0;
    }

    // 탭 컨트롤러 설정
    tabController = TabController(length: 3, vsync: this, initialIndex: initialTabIndex);
    currentTabIndex.value = initialTabIndex;

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentTabIndex.value = tabController.index;
      }
    });

    fetchBookInfo();
    fetchAllRecords();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // ==========================
  // 📌 데이터 조회 (GET)
  // ==========================

  // 1. 책 정보 (헤더용)
  Future<void> fetchBookInfo() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/books/$bookId"));
      if (res.statusCode == 200) {
        bookInfo.value = jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      print("❌ Book Info Error: $e");
    }
  }

  // 2. 전체 기록 조회 (초기 진입용)
  Future<void> fetchAllRecords() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchBookmarks(),
        fetchHighlights(),
        fetchMemos(),
      ]);
    } catch (e) {
      print("❌ Error fetching records: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 개별 리스트 조회 함수 (작성 후 갱신을 위해 필요)
  Future<void> fetchBookmarks() async => await _fetchData("/bookmarks/books/$bookId", bookmarks);
  Future<void> fetchHighlights() async => await _fetchData("/highlights/books/$bookId", highlights);
  Future<void> fetchMemos() async => await _fetchData("/notes/books/$bookId", memos);

  // 내부 공통 조회 함수
  Future<void> _fetchData(String endpoint, RxList<Map<String, dynamic>> targetList) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
        targetList.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
        _applySort(targetList); // 데이터 로드 후 정렬 적용
      }
    } catch (e) {
      print("❌ Fetch Error ($endpoint): $e");
    }
  }

  // ==========================
  // 📌 정렬 로직
  // ==========================
  void _applySort(RxList<Map<String, dynamic>> list) {
    if (currentSort.value == "page") { // 페이지 순
      list.sort((a, b) => (a['page'] ?? 0).compareTo(b['page'] ?? 0));
    } else { // 날짜 순
      list.sort((a, b) => (b['created_date'] ?? "").compareTo(a['created_date'] ?? ""));
    }
    list.refresh();
  }

  void changeSort(String type) {
    currentSort.value = type;
    _applySort(bookmarks);
    _applySort(highlights);
    _applySort(memos);
    Get.back(); // 바텀시트 닫기
  }

  // ==========================
  // 📌 삭제 로직 (DELETE)
  // ==========================
  Future<void> deleteItem(String type, int id) async {
    final token = box.read("access_token");
    if (token == null) return;

    String endpoint = "";
    if (type == 'bookmark') endpoint = "/bookmarks/$id";
    else if (type == 'highlight') endpoint = "/highlights/$id";
    else if (type == 'memo') endpoint = "/notes/$id";

    try {
      final res = await http.delete(
        Uri.parse("$baseUrl$endpoint"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        Get.back(); // 시트 닫기
        Get.snackbar("삭제 완료", "기록이 삭제되었습니다.");

        // 리스트에서 즉시 제거 (UI 반응성 향상)
        if (type == 'bookmark') bookmarks.removeWhere((e) => e['id'] == id);
        else if (type == 'highlight') highlights.removeWhere((e) => e['id'] == id);
        else if (type == 'memo') memos.removeWhere((e) => e['id'] == id);
      } else {
        Get.snackbar("오류", "삭제 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Delete Error: $e");
    }
  }

  // ==========================
  // 📌 작성 로직 (POST)
  // ==========================

  // 1. 북마크 작성
  Future<void> createBookmark(int page, String memo) async {
    final token = box.read('access_token');
    if (token == null) return;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/bookmarks"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "book_id": bookId,
          "page": page,
          "memo": memo.isEmpty ? null : memo,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("성공", "북마크가 저장되었습니다.");
        fetchBookmarks(); // 리스트 갱신
      } else {
        Get.snackbar("오류", "저장 실패: ${res.body}");
      }
    } catch (e) {
      print("❌ Create bookmark error: $e");
    }
  }

  // 2. 북마크 수정
  Future<void> updateBookmark(int bookmark_id, int page, String memo) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/bookmarks/$bookmark_id"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode({
          "page": page,
          "memo": memo,
        }),
      );
      if (res.statusCode == 200) {
        Get.snackbar("성공", "북마크가 수정되었습니다.");
        fetchBookmarks(); // 리스트 갱신
      } else {
        Get.snackbar("오류", "수정 실패: ${res.body}");
      }
    } catch (e) { print(e); }
  }

  // 3. 하이라이트 작성
  Future<void> createHighlight(int page, String sentence, String memo, bool isPublic) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/highlights"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode({
          "book_id": bookId,
          "page": page,
          "sentence": sentence,
          "is_public": isPublic,
          "memo": memo.isEmpty ? null : memo,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("성공", "하이라이트가 저장되었습니다.");
        fetchHighlights(); // 🔥 리스트 갱신
      } else {
        Get.snackbar("오류", "저장 실패: ${res.body}");
      }
    } catch (e) { print(e); }
  }

  // 4. 하이라이트 수정
  Future<void> updateHighlight(int highlight_id, int page, String sentence, String memo, bool isPublic) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/highlights/$highlight_id"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode({
          "page": page,
          "sentence": sentence,
          "is_public": isPublic,
          "memo": memo,
        }),
      );
      if (res.statusCode == 200) {
        Get.snackbar("성공", "하이라이트가 수정되었습니다.");
        fetchHighlights();
      }
    } catch (e) { print(e); }
  }

  // 5. 메모 작성
  Future<void> createMemo(int page, String content) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/notes"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode({
          "book_id": bookId,
          "content": content,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("성공", "메모가 저장되었습니다.");
        fetchMemos(); // 🔥 리스트 갱신
      } else {
        Get.snackbar("오류", "저장 실패: ${res.body}");
      }
    } catch (e) { print(e); }
  }

  // 6. 메모 수정
  Future<void> updateMemo(int note_id, String content) async {
    final token = box.read('access_token');
    if (token == null) return;
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/notes/$note_id"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode({
          "content": content,
        }),
      );
      if (res.statusCode == 200) {
        Get.snackbar("성공", "메모가 수정되었습니다.");
        fetchMemos();
      }
    } catch (e) { print(e); }
  }
}