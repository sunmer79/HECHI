import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../review_list/controllers/review_list_controller.dart';

class ReviewDetailController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final RxMap<String, dynamic> review = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> book = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;

  final RxBool isLoadingReview = true.obs;
  final RxBool isLoadingBook = true.obs;
  final RxBool isLoadingComments = true.obs;

  final TextEditingController commentInputController = TextEditingController();
  late RxBool isLiked = false.obs;
  late RxInt likeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is int)
      fetchReviewDetail(args);
    else {
      Get.back();
      Get.snackbar("오류", "잘못된 접근입니다.");
    }
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }

  // ==========================
  // 📌 리뷰 데이터 세팅 (공통 함수)
  // ==========================
  void setReviewData(Map<String, dynamic> data) {
    review.value = data;
    isLiked.value = data['is_liked'] ?? false;
    likeCount.value = (data['like_count'] is int) ? data['like_count'] : 0;
    isLoadingReview.value = false;
  }

  // ==========================
  // 📌 리뷰 상세 조회 (ID로 조회)
  // ==========================
  Future<void> fetchReviewDetail(int reviewId) async {
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
  // 📌 댓글 목록 조회
  // ==========================
  Future<void> fetchComments() async {
    try {
      isLoadingComments.value = true;
      final token = box.read('access_token');
      final int reviewId = review['id'];
      if (reviewId == null) return;
      final headers = {"Content-Type": "application/json"};
      if (token != null) headers["Authorization"] = "Bearer $token";

      final res = await http.get(
        Uri.parse("$baseUrl/reviews/$reviewId/comments"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
        comments.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
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

      final int reviewId = review['id'];
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
        if (Get.isRegistered<ReviewListController>()) {
          await Get.find<ReviewListController>().fetchReviews();
        }
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
    if (isLiked.value) likeCount.value++; else likeCount.value--;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/${review['id']}/like"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode != 200) {
        isLiked.value = prevLiked;
        if (prevLiked) likeCount.value++; else likeCount.value--;
        print("❌ 좋아요 실패: ${res.statusCode}");
      }
    } catch (e) {
      isLiked.value = prevLiked;
      if (prevLiked) likeCount.value++; else likeCount.value--;
      print("❌ 좋아요 에러: $e");
    }
  }
}