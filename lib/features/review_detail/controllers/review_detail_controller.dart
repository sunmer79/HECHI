import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../review_list/controllers/review_list_controller.dart';
import '../../book_detail_page/controllers/book_detail_controller.dart';
import '../../book_detail_page/widgets/overlays/comment_overlay.dart';

class ReviewDetailController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int reviewId = Get.arguments ?? 1;

  final RxMap<String, dynamic> review = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> book = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;

  final RxBool isLoadingReview = true.obs;
  final RxBool isLoadingBook = true.obs;
  final RxBool isLoadingComments = true.obs;

  final TextEditingController commentInputController = TextEditingController();
  late RxBool isLiked = false.obs;
  late RxInt likeCount = 0.obs;
  final RxBool isMyReview = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviewDetail();
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }

  // ==========================
  // 📌 리뷰 데이터 세팅
  // ==========================
  void setReviewData(Map<String, dynamic> data) {
    review.value = data;
    isLiked.value = data['is_liked'] ?? false;
    likeCount.value = data["like_count"] ?? 0;
    isMyReview.value = data["is_my_review"] ?? false;

    isLoadingReview.value = false;
  }

  // ==========================
  // 📌 코멘트 상세 조회
  // ==========================
  Future<void> fetchReviewDetail() async {
    try {
      isLoadingReview.value = true;
      final token = box.read('access_token');
      final headers = {"Content-Type": "application/json"};
      if (token != null) headers["Authorization"] = "Bearer $token";

      final res = await http.get(
        Uri.parse("$baseUrl/reviews/$reviewId"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setReviewData(data);
        if (data['book_id'] != null) {
          fetchBookDetail(data['book_id']);
        }
        fetchComments();
      } else {
        print("❌ 리뷰 상세 조회 실패: ${res.statusCode}");
        Get.back();
        Get.snackbar("오류", "리뷰를 불러오지 못했습니다.");
      }
    } catch (e) {
      print("❌ 리뷰 상세 에러: $e");
      Get.back();
    }
  }

  // ==========================
  // 📌 책 상세 정보 조회 (제목, 표지, 저자 등)
  // ==========================
  Future<void> fetchBookDetail(int? bookId) async {
    if (bookId == null) return;
    try {
      isLoadingBook.value = true;
      final res = await http.get(Uri.parse("$baseUrl/books/$bookId"));

      if (res.statusCode == 200) {
        book.value = jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (e) {
      print("❌ Book Error: $e");
    } finally {
      isLoadingBook.value = false;
    }
  }

  // ==========================
  // 📌 코멘트 삭제
  // ==========================
  Future<void> deleteReview() async {
    if (isLoadingReview.value) return;

    final token = box.read("access_token");
    if (token == null) return;

    final rating = (review["rating"] as num?)?.toDouble() ?? 0.0;

    isLoadingReview.value = true;

    try {
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
          "book_id": review['book_id'],
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
        syncWithOtherControllers(reviewId, "", false, rating);

        Get.back();
        Get.snackbar("완료", "삭제되었습니다.");
      } else {
        Get.snackbar("오류", "삭제 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Delete Error: $e");
    }
  }

  // ==========================
  // 📌 코멘트 수정
  // ==========================
  Future<void> updateReview(String newContent, bool isSpoiler) async {
    final rating = (review["rating"] as num?)?.toDouble() ?? 0.0;

    try {
      final token = box.read("access_token");
      if (token == null) return;

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final body = jsonEncode({
        "book_id": review['book_id'],
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
        review['content'] = newContent;
        review['is_spoiler'] = isSpoiler;
        review.refresh();

        syncWithOtherControllers(reviewId, newContent, isSpoiler, rating);

        Get.snackbar("성공", "코멘트가 수정되었습니다.");
      } else {
        Get.snackbar("오류", "수정 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 수정 에러: $e");
    }
  }

  // ==========================
  // 📌 코멘트 수정 Overlay
  // ==========================
  void showEditOverlay() {
    Get.bottomSheet(
      CommentOverlay(
        isEditMode: true,
        initialText: review['content'],
        initialSpoiler: review['is_spoiler'],
        onSubmit: (newContent, newSpoiler) async {
          updateReview(newContent, newSpoiler);
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
  // 📌 댓글 목록 조회
  // ==========================
  Future<void> fetchComments() async {
    try {
      isLoadingComments.value = true;

      final token = box.read('access_token');
      final headers = {"Content-Type": "application/json"};
      if (token != null) headers["Authorization"] = "Bearer $token";

      final res = await http.get(
        Uri.parse("$baseUrl/reviews/$reviewId/comments"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final list = jsonDecode(utf8.decode(res.bodyBytes));
        comments.value = list.map((e) => Map<String, dynamic>.from(e)).toList();

        final int count = comments.length;
        review["comment_count"] = count;
        review.refresh();
        syncCommentCount(reviewId, count);
      }
    } catch (e) {
      print("❌ 댓글 에러: $e");
    } finally {
      isLoadingComments.value = false;
    }
  }

  // ==========================
  // 📌 댓글 작성
  // ==========================
  Future<void> postComment() async {
    final content = commentInputController.text.trim();
    if (content.isEmpty) return;

    try {
      final token = box.read('access_token');
      if (token == null) return;

      final res = await http.post(
        Uri.parse("$baseUrl/reviews/$reviewId/comments"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"content": content}),
      );

      if (res.statusCode == 200) {
        commentInputController.clear();
        Get.focusScope?.unfocus();
        await fetchComments();

        Get.snackbar("성공", "댓글이 등록되었습니다.");
      } else {
        Get.snackbar("오류", "댓글 등록 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 댓글 작성 에러: $e");
    }
  }

  // ==========================
  // 📌 댓글 삭제
  // ==========================
  Future<void> deleteComment(int commentId) async {
    try {
      final token = box.read('access_token');
      final res = await http.delete(
        Uri.parse("$baseUrl/reviews/comments/$commentId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        Get.snackbar("완료", "댓글이 삭제되었습니다.");
        comments.removeWhere((e) => e['id'] == commentId);

        final newCount = comments.length;
        review["comment_count"] = newCount;
        review.refresh();
        syncCommentCount(reviewId, newCount);
      }
    } catch (e) {
      print("❌ 댓글 삭제 에러: $e");
    }
  }

  // ==========================
  // 📌 좋아요 토글
  // ==========================
  Future<void> toggleLike() async {
    final token = box.read('access_token');
    if (token == null) return;

    final bool prevLiked = isLiked.value;
    isLiked.value = !prevLiked;
    likeCount.value += prevLiked ? -1 : 1;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/$reviewId/like"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode != 200) {
        isLiked.value = prevLiked;
        likeCount.value += prevLiked ? 1 : -1;
        print("❌ 좋아요 실패: ${res.statusCode}");
      }
    } catch (e) {
      isLiked.value = prevLiked;
      likeCount.value += prevLiked ? 1 : -1;
      print("❌ 좋아요 에러: $e");
    }
  }

  // ==========================
  // 🔄 상태 동기화
  // ==========================
  void syncWithOtherControllers(int targetId, String content, bool isSpoiler, double rating) {
    if (Get.isRegistered<ReviewListController>()) {
      final listCtrl = Get.find<ReviewListController>();

      if (rating == 0.0 && content.isEmpty) {
        listCtrl.reviews.removeWhere((r) => r['id'] == targetId);
      } else {
        final index = listCtrl.reviews.indexWhere((r) => r['id'] == targetId);
        if (index != -1) {
          listCtrl.reviews[index]['content'] = content.trim().isEmpty ? null : content;
          listCtrl.reviews[index]['is_spoiler'] = isSpoiler;
          listCtrl.reviews.refresh();
        }
      }
      listCtrl.reviews.refresh();
    }

    if (Get.isRegistered<BookDetailController>()) {
      final bookCtrl = Get.find<BookDetailController>();
      if (bookCtrl.myReviewId == targetId) {
        bookCtrl.myContent.value = content;
        bookCtrl.isSpoiler.value = isSpoiler;
        bookCtrl.isCommented.value = false;

        if (rating == 0.0 && content.isEmpty) {
          bookCtrl.myReviewId = -1;
        }
      }
    }
  }

  // ==========================
  // 📌 댓글 카운트 동기화
  // ==========================
  void syncCommentCount(int reviewId, int count) {
    if (Get.isRegistered<ReviewListController>()) {
      final list = Get.find<ReviewListController>();

      final index = list.reviews.indexWhere((r) => r["id"] == reviewId);
      if (index != -1) {
        list.reviews[index]["comment_count"] = count;
        list.reviews.refresh();
      }
    }

    if (Get.isRegistered<BookDetailController>()) {
      final b = Get.find<BookDetailController>();
      final index = b.reviews.indexWhere((r) => r["id"] == reviewId);

      if (index != -1) {
        b.reviews[index]["comment_count"] = count;
        b.reviews.refresh();
      }
    }
  }
}