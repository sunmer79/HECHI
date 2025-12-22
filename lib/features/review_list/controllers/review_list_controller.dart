import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../book_detail_page/controllers/book_detail_controller.dart';
import '../../book_detail_page/widgets/overlays/comment_overlay.dart';
import 'package:http/http.dart' as http;

class ReviewListController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int bookId = Get.arguments ?? 1;

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  final RxString currentSort = "likes".obs;
  String get sortText => currentSort.value == "likes" ? "좋아요 순" : "최신 순";

  final RxSet<int> unlockedSpoilers = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  @override
  void onReady() {
    super.onReady();
    fetchReviews();
  }

  // ==========================
  // 코멘트 목록 조회
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

        reviews.value = list.map((e) {
          final map = Map<String, dynamic>.from(e);
          map['comment_count'] = map['comment_count'] ?? 0;
          map['like_count'] = map['like_count'] ?? 0;
          return map;
        }).toList();

        _applySort();
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
  // 정렬 로직
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
  // 정렬 변경
  // ==========================
  void changeSort(String type) {
    currentSort.value = type;
    _applySort();
    Get.back();
  }

  // ==========================
  // 스포일러 보기 토글
  // ==========================
  void unlockSpoiler(int reviewId) {
    unlockedSpoilers.add(reviewId);
  }

  // ==========================
  // 좋아요 토글 API 호출
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

    if (Get.isRegistered<BookDetailController>()) {
      Get.find<BookDetailController>().syncReviewChange({
        "review_id": reviewId,
        "status": "updated",
        "is_liked": review["is_liked"],
        "like_count": review["like_count"],
      });
    }

    try {
      final token = box.read("access_token");
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/$reviewId/like"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode != 200) {
        throw Exception("like failed");
      }
    } catch (e) {
      print("❌ 좋아요 토글 실패: $e");

      await fetchReviews();
    }
  }

  // ==========================
  // 코멘트 삭제
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
        reviews.removeWhere((r) => r['id'] == reviewId);
        reviews.refresh();

        Get.snackbar("완료", "삭제되었습니다.");

        if (Get.isRegistered<BookDetailController>()) {
          final bool isRatingAlive = rating > 0.0;

          Get.find<BookDetailController>().syncReviewChange({
            "review_id": reviewId,
            "status": "deleted",
            "keep_rating": isRatingAlive,
          });
        }
        await fetchReviews();
      } else {
        Get.snackbar("오류", "삭제 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Delete Error: $e");
    }
  }

  // ==========================
  // 코멘트 수정
  // ==========================
  Future<void> updateReview(int reviewId, String newContent, bool isSpoiler) async {
    final token = box.read("access_token");
    if (token == null) return;
    final target = reviews.firstWhereOrNull((e) => e['id'] == reviewId);
    if (target == null) return;

    final double rating = (target["rating"] as num?)?.toDouble() ?? 0.0;

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "book_id": bookId,
      "rating": rating == 0.0 ? null : rating,
      "content": newContent,
      "is_spoiler": isSpoiler,
    });


    final res = await http.post(
      Uri.parse("$baseUrl/reviews/upsert"),
      headers: headers,
      body: body,
    );

    if (res.statusCode == 200) {
      final index = reviews.indexWhere((e) => e['id'] == reviewId);
      if (index != -1) {
        reviews[index]['content'] = newContent;
        reviews[index]['is_spoiler'] = isSpoiler;
        reviews.refresh();
      }
      Get.snackbar("성공", "코멘트가 수정되었습니다.");

      if (Get.isRegistered<BookDetailController>()) {
        Get.find<BookDetailController>().syncReviewChange({
          "review_id": reviewId,
          "status": "updated",
          "content": newContent,
          "is_spoiler": isSpoiler,
          // rating, like_count 등도 전달
        });
      }
    } else {
      Get.snackbar("오류", "수정 실패: ${res.statusCode}");
    }
  }

  // ==========================
  // 코멘트 수정 Overlay
  // ==========================
  void editReview(int reviewId) {
    Get.back();

    final target = reviews.firstWhereOrNull((element) => element['id'] == reviewId);
    if (target == null) return;

    final String currentContent = target['content'] ?? "";
    final bool currentSpoiler = target['is_spoiler'] ?? false;

    if (!Get.isRegistered<BookDetailController>()) {
      Get.snackbar("오류", "상세 페이지 정보를 불러올 수 없습니다.");
      return;
    }

    Get.bottomSheet(
      CommentOverlay(
        isEditMode: true,
        initialText: currentContent,
        initialSpoiler: currentSpoiler,
        onSubmit: (newContent, newSpoiler) {
          updateReview(reviewId, newContent, newSpoiler);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
    );
  }

  // ==========================
  // 리뷰 동기화
  // ==========================
  void syncReviewChange(Map<String, dynamic> result) {
    final int reviewId = result['review_id'];
    final String status = result['status'] ?? 'updated';

    if (status == 'deleted') {
      reviews.removeWhere((r) => r['id'] == reviewId);
      reviews.refresh();
      return;
    }

    final index = reviews.indexWhere((r) => r['id'] == reviewId);
    if (index != -1) {
      if (result.containsKey('is_liked')) reviews[index]['is_liked'] = result['is_liked'];
      if (result.containsKey('like_count')) reviews[index]['like_count'] = result['like_count'];
      if (result.containsKey('content')) reviews[index]['content'] = result['content'];
      if (result.containsKey('is_spoiler')) reviews[index]['is_spoiler'] = result['is_spoiler'];
      if (result.containsKey('comment_count')) reviews[index]['comment_count'] = result['comment_count'];

      reviews.refresh();
    }
  }
}