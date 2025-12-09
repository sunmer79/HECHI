import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../book_detail_page/controllers/book_detail_controller.dart';
import 'package:http/http.dart' as http;

class ReviewListController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int bookId = Get.arguments ?? 1;

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  // 정렬 상태 (latest: 최신순, likes: 좋아요순)
  final RxString currentSort = "likes".obs;
  String get sortText => currentSort.value == "likes" ? "좋아요 순" : "최신 순";

  // 스포일러 해제된 리뷰 ID 목록
  final RxSet<int> unlockedSpoilers = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  // ==========================
  // 📌 리뷰 목록 조회 (데이터 로드 후 즉시 정렬)
  // ==========================
  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;
      final token = box.read('access_token');
      final headers = {"Content-Type": "application/json"};
      if (token != null) headers["Authorization"] = "Bearer $token";

      final res = await http.get(
        Uri.parse("$baseUrl/reviews/books/$bookId"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(res.body);
        reviews.value = list
            .map((e) => Map<String, dynamic>.from(e))
            .where((e) => (e["content"] ?? "").toString().isNotEmpty)
            .toList();
        _applySort(); // 데이터 로드 후 정렬 적용
      } else {
        print("❌ 리뷰 로드 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // 📌 정렬 로직 (내부 함수)
  // ==========================
  void _applySort() {
    if (currentSort.value == "likes") { // 좋아요 많은 순 (내림차순)
      reviews.sort((a, b) => (b["like_count"] ?? 0).compareTo(a["like_count"] ?? 0));
    } else { // 최신 순 (ID 내림차순)
      reviews.sort((a, b) => (b["id"] ?? 0).compareTo(a["id"] ?? 0));
    }
    reviews.refresh();
  }

  // ==========================
  // 📌 정렬 변경 (UI에서 호출)
  // ==========================
  void changeSort(String type) {
    currentSort.value = type;
    _applySort();
    Get.back(); // 바텀시트 닫기
  }

  // ==========================
  // 📌 스포일러 보기 토글
  // ==========================
  void unlockSpoiler(int reviewId) {
    unlockedSpoilers.add(reviewId);
  }

  // ==========================
  // 📌 좋아요 토글 API 호출
  // ==========================
  Future<void> toggleLike(int reviewId) async {
    final index = reviews.indexWhere((r) => r["id"] == reviewId);
    if (index == -1) return;

    final review = reviews[index];

    final bool prev = review["is_liked"] ?? false;

    review["is_liked"] = !prev;
    review["like_count"] = (review["like_count"] ?? 0) + (prev ? -1 : 1);
    reviews[index] = review;
    reviews.refresh();

    try {
      final token = box.read("access_token");
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/$reviewId/like"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode != 200) {
        review["is_liked"] = prev;
        review["like_count"] = (review["like_count"] ?? 0) + (prev ? 1 : -1);
        reviews[index] = review;
        reviews.refresh();
      }
    } catch (e) {
      review["is_liked"] = prev;
      review["like_count"] = (review["like_count"] ?? 0) + (prev ? 1 : -1);
      reviews[index] = review;
      reviews.refresh();
    }
  }

  // ==========================
  // 📌 리뷰 삭제
  // ==========================
  Future<void> deleteReview(int reviewId) async {
    try {
      final token = box.read("access_token");
      if (token == null) return;

      final target = reviews.firstWhereOrNull((element) => element['id'] == reviewId);
      if (target == null) {
        Get.snackbar("오류", "리뷰를 찾을 수 없습니다.");
        return;
      }

      final rating = (target["rating"] as num?)?.toDouble() ?? 0.0;

      http.Response res;

      if (rating == 0.0) {
        print("🔹 별점 0점이므로 완전 삭제 요청 (DELETE)");
        res = await http.delete(
          Uri.parse("$baseUrl/reviews/$reviewId"),
          headers: {"Authorization": "Bearer $token"},
        );
      } else {
        print("🔹 별점($rating)은 유지하고 내용만 삭제 요청 (UPSERT)");

        final headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        };

        final body = jsonEncode({
          "book_id": bookId,
          "rating": rating,
          "content": null,
          "is_spoiler": false,
        });

        res = await http.post(
          Uri.parse("$baseUrl/reviews/upsert"),
          headers: headers,
          body: body,
        );
        print("🚀 리뷰 삭제 요청: $body");

      }
      if (res.statusCode == 200 || res.statusCode == 204) {
        final data = jsonDecode(res.body);
        Get.snackbar("완료", "삭제되었습니다.");
        print("받은 값: ${data['content']}");
        // await fetchReviews();

        reviews.removeWhere((e) => e['id'] == reviewId);
        reviews.refresh();

        if (Get.isRegistered<BookDetailController>()) {
          final detail = Get.find<BookDetailController>();

          detail.myRating.value = rating > 0 ? rating : 0.0;
          detail.myContent.value = "";
          detail.isCommented.value = false;
          if (rating == 0) detail.myReviewId = -1;

          await detail.fetchReviews();
          await detail.fetchBookDetail();
        }
      } else {
        Get.snackbar("오류", "삭제 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Delete Error: $e");
    }
  }

  // ==========================
  // 📌 리뷰 수정 페이지로 이동
  // ==========================
  void editReview(int reviewId) {
    Get.back(); // 바텀시트 닫기
    Get.toNamed("/review_detail", arguments: reviewId); // 상세/수정 페이지로 이동
  }
}