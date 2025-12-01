import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../widgets/overlays/comment_overlay.dart';
import '../widgets/overlays/reading_status_overlay.dart';
import '../widgets/overlays/more_menu_overlay.dart';

class BookDetailController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 라우트에서 전달받는 bookId (없으면 1)
  final int bookId = Get.arguments ?? 1;

  // ====== 공통 상태 ======
  final RxBool isLoading = true.obs;

  // 책 정보 (BookDetailResponse 전체를 Map으로 저장)
  final RxMap<String, dynamic> book = <String, dynamic>{}.obs;

  // 리뷰 리스트 (ReviewResponse[])
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  // 평점 히스토그램 최대값 (그래프 Y축 스케일용)
  final RxInt maxRatingCount = 1.obs;

  // 화면 상단 별점(내 별점) – overlay에서 사용
  final RxDouble myRating = 0.0.obs;

  // 버튼 상태
  final RxBool isWishlisted = false.obs;
  final RxBool isCommented = false.obs; // 코멘트 작성 여부
  final RxString readingStatus = "".obs; // "", "reading", "finished" 등

  // 내가 방금/예전에 쓴 리뷰의 id (상세 페이지 이동용)
  int myReviewId = -1;

  @override
  void onInit() {
    super.onInit();
    fetchBookDetail();
    fetchReviews();
    fetchReadingStatus();
  }

  // ==========================
  // 📌 책 상세 조회
  // GET /books/{book_id}
  // ==========================
  Future<void> fetchBookDetail() async {
    try {
      isLoading.value = true;
      final res = await http.get(Uri.parse("$baseUrl/books/$bookId"));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        book.value = data;

        // rating_histogram 최대값 계산
        final histogram =
        Map<String, dynamic>.from(data["rating_histogram"] ?? {});
        if (histogram.isNotEmpty) {
          maxRatingCount.value =
          histogram.values.reduce((a, b) => a > b ? a : b) as int;
          if (maxRatingCount.value == 0) maxRatingCount.value = 1;
        }
      } else {
        Get.snackbar("오류", "책 정보를 불러오지 못했습니다.");
      }
    } catch (e) {
      print("❌ Book API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // 📌 리뷰 목록 조회
  // GET /reviews/books/{book_id}
  // ==========================
  Future<void> fetchReviews() async {
    try {
      final res =
        await http.get(Uri.parse("$baseUrl/reviews/books/$bookId"));

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        reviews.value =
            list.map((e) => Map<String, dynamic>.from(e)).toList();
        /// 내가 작성한 리뷰인지 판별
        isCommented.value = reviews.any((e) => e["is_my_review"] == true);
      } else {
        print("리뷰 불러오기 실패: ${res.body}");
      }
    } catch (e) {
      print("Review API Error: $e");
    }
  }

  // ==========================
  // 📌 독서 상태 조회
  // GET /reading-status/summary/{book_id}
  // (예시 응답: "reading" 또는 {"status":"reading"})
  // ==========================
  Future<void> fetchReadingStatus() async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl/reading-status/summary/$bookId"));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        readingStatus.value = decoded is String ? decoded : decoded["status"] ?? "";
        isWishlisted.value = (readingStatus.value == "wishlist");
      }
    } catch (e) {
      print("Reading-Status GET Error: $e");
    }
  }

  // ==========================
  // 📌 내 별점 변경 (UI 전용)
  // ==========================
  void updateMyRating(double rating) {
    myRating.value = rating;
    // 별점 POST API가 생기면 여기에서 호출
  }

  // ==========================
  // 📌 읽고싶어요 토글 (지금은 로컬 상태만)
  // ==========================
  Future<void> onWantToRead() async {
    final newState = readingStatus.value == "wishlist" ? "" : "wishlist";

    final prev = readingStatus.value;
    readingStatus.value = newState;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reading-status/update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"book_id": bookId, "status": newState}),
      );

      if (res.statusCode != 200) {
        readingStatus.value = prev; // rollback
        Get.snackbar("오류", "상태 변경 실패");
      }
    } catch (e) {
      readingStatus.value = prev;
    }
  }

  // ==========================
  // 📌 코멘트 버튼 클릭
  //   - 아직 작성 X  → Overlay 열기
  //   - 이미 작성 O → 내가 쓴 리뷰 상세로 이동
  // ==========================
  void onWriteReview() {
    if (!isCommented.value) {
      readingStatus.value = "reviewed";
    }

    if (isCommented.value && myReviewId != -1) {
      Get.toNamed("/review/detail", arguments: myReviewId);
    } else {
      Get.bottomSheet(
        CommentOverlay(onSubmit: submitComment),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
      );
    }
  }

  // ==========================
  // 📌 코멘트 등록
  // POST /reviews/
  // ==========================
  Future<void> submitComment(String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar("오류", "내용을 입력해주세요.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "book_id": bookId,
          "rating": myRating.value.toInt(),
          "content": content,
          "is_spoiler": false,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        isCommented.value = true;
        await fetchReviews();
        Get.back();
        Get.snackbar("완료", "코멘트가 등록되었습니다.");
      } else {
        Get.snackbar("오류", "코멘트 등록 실패");
      }
    } catch (e) {
      print("❌ Review POST Error: $e");
    }
  }

  // ==========================
  // 📌 독서 상태 Overlay 띄우기
  // ==========================
  void onReadingStatus() {
    Get.bottomSheet(
      ReadingStatusOverlay(onSelect: updateReadingStatus),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
    );
  }

  // ==========================
  // 📌 독서 상태 업데이트
  // POST /reading-status/update
  // body: { "book_id": int, "status": string }
  // ==========================
  Future<void> updateReadingStatus(String status) async {
    final prev = readingStatus.value;
    readingStatus.value = status;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reading-status/update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"book_id": bookId, "status": status}),
      );

      if (res.statusCode == 200) {
        Get.back();
        Get.snackbar("완료", "'${status == "reading" ? "읽는 중" : "완독한"}'으로 변경되었습니다.");
      } else {
        readingStatus.value = prev; // rollback
      }
    } catch (e) {
      readingStatus.value = prev;
    }
  }

  // ==========================
  // 📌 더보기 메뉴
  // ==========================
  void openMoreMenu() {
    Get.bottomSheet(
      MoreMenuOverlay(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
    );
  }

  // ======================
  Future<void> toggleLike(int reviewId, RxBool isLiked, RxInt likeCount) async {
    final bool prevLiked = isLiked.value;

    // Optimistic update
    isLiked.value = !prevLiked;
    likeCount.value += prevLiked ? -1 : 1;

    try {
      final String url = "$baseUrl/reviews/$reviewId/like";
      final response = prevLiked
          ? await http.delete(Uri.parse(url))
          : await http.post(Uri.parse(url));

      if (response.statusCode != 200 && response.statusCode != 201) {
        // rollback
        isLiked.value = prevLiked;
        likeCount.value += prevLiked ? 1 : -1;
        print("❌ Like API failed: ${response.body}");
      }
    } catch (e) {
      // rollback
      isLiked.value = prevLiked;
      likeCount.value += prevLiked ? 1 : -1;
      print("❌ Like Toggle Error: $e");
    }
  }
}
