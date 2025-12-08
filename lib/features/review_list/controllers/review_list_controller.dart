import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../book_detail_page/controllers/book_detail_controller.dart';
import 'package:http/http.dart' as http;

class ReviewListController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int bookId = Get.arguments ?? 1;
  final int myUserId = GetStorage().read("user_id") ?? -1;

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
        final parsedList = list
            .map((e) => Map<String, dynamic>.from(e))
            .where((e) => (e["content"] ?? "").toString().isNotEmpty)
            .toList();

        reviews.value = parsedList;
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
    if (currentSort.value == "likes") {
      // 좋아요 많은 순 (내림차순)
      reviews.sort((a, b) => (b["like_count"] ?? 0).compareTo(a["like_count"] ?? 0));
    } else {
      // 최신 순 (ID 내림차순)
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
    final token = box.read("access_token");
    if (token == null) {
      Get.snackbar("알림", "로그인이 필요합니다.");
      return;
    }

    try {
      // API 호출 (POST /reviews/{id}/like)
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/$reviewId/like"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        print("✅ 좋아요 변경 성공 (ID: $reviewId)");
      } else {
        print("❌ 좋아요 실패: ${res.statusCode}");
        // 필요하다면 여기서 리스트를 다시 불러오거나(fetchReviews), 에러 메시지를 띄웁니다.
      }
    } catch (e) {
      print("❌ 좋아요 에러: $e");
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
      final String? content = target['content'];
      http.Response res;

      print("--------------------------------------------------");
      print("🔍 [디버깅] 삭제 프로세스 시작 (ID: $reviewId, Rating: $rating)");

      if (rating == 0.0) {
        print("🔹 별점 0점이므로 완전 삭제 요청 (DELETE)");
        res = await http.delete(
          Uri.parse("$baseUrl/reviews/$reviewId"),
          headers: {"Authorization": "Bearer $token"},
        );
      } else {
        print("🔹 별점($rating)은 유지하고 내용만 삭제 요청 (UPSERT)");
        res = await http.post(
          Uri.parse("$baseUrl/reviews/upsert"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "book_id": bookId,
            "rating": rating,
            "content": null,
            "is_spoiler": false,
          }),
        );
      }

      if (res.statusCode == 200 || res.statusCode == 204) {
        Get.snackbar("완료", "삭제되었습니다.");

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
    Get.toNamed("/review/detail", arguments: reviewId); // 상세/수정 페이지로 이동
  }
}