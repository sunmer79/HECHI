import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../widgets/overlays/comment_overlay.dart';
import '../widgets/overlays/reading_status_overlay.dart';
import '../widgets/overlays/more_menu_overlay.dart';

class BookDetailController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  final int bookId = Get.arguments ?? 1;

  final RxBool isLoading = true.obs;
  final RxMap book = {}.obs;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxInt maxRatingCount = 1.obs;
  final RxDouble myRating = 0.0.obs;

  final RxBool isWishlisted = false.obs;
  final RxBool isCommented = false.obs;

  final RxString readingStatus = "PENDING".obs;

  int myReviewId = -1;

  bool get isReadingOrCompleted =>
      ["READING", "COMPLETED"].contains(readingStatus.value);

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      await fetchBookDetail();
      await fetchReviews();
      await fetchReadingStatus();
    });
  }

  // ==========================
  // 📌 책 상세 조회
  // ==========================
  Future<void> fetchBookDetail() async {
    try {
      isLoading.value = true;
      final res = await http.get(Uri.parse("$baseUrl/books/$bookId"));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        book.value = data;

        final histogram = Map<String, dynamic>.from(data["rating_histogram"] ?? {});
        if (histogram.isNotEmpty) {
          maxRatingCount.value = histogram.values.reduce((a, b) => a > b ? a : b) as int;
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
  // ==========================
  Future<void> fetchReviews() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/reviews/books/$bookId"));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        reviews.value = list.map((e) => Map<String, dynamic>.from(e)).toList();

        final mine = reviews.firstWhereOrNull((e) => e["is_my_review"] == true);

        if (mine != null) {
          isCommented.value = true;
          myReviewId = mine["id"];
          myRating.value = (mine["rating"] as num).toDouble();
        } else {
          isCommented.value = false;
          myRating.value = 0.0;
        }
      }
    } catch (e) {
      print("Review error: $e");
    }
  }

  // ==========================
  // 📌 독서 상태 조회
  // ==========================
  Future<void> fetchReadingStatus() async {
    try {
      final token = box.read('access_token');
      if (token == null) return;

      final res = await http.get(
        Uri.parse("$baseUrl/reading-status/summary/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        readingStatus.value = decoded["status"] ?? "NONE";
      }
    } catch (e) {
      print("❌ Reading-Status GET Error: $e");
    }
  }

  // ==========================
  // 📌 내 별점 변경
  // ==========================
  void updateMyRating(double rating) {
    myRating.value = rating;
  }

  // ==========================
  // 📌 공통 상태 업데이트 함수 (핵심 로직)
  // ==========================
  Future<void> updateReadingStatus(String status) async {
    final token = box.read("access_token");
    if (token == null) return;

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reading-status/update"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"book_id": bookId, "status": status}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        readingStatus.value = status;
        Get.back(); // 오버레이 닫기
        Get.snackbar("완료", "서가 상태가 변경되었습니다.");
      } else {
        Get.snackbar("오류", "상태 변경 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Status Update Error: $e");
    }
  }

  // ==========================
  // 📌 읽고싶어요
  // ==========================
  Future<void> onWantToRead() async {
    final token = box.read("access_token");
    if (token == null) {
      Get.snackbar("알림", "로그인이 필요합니다.");
      return;
    }

    try {
      if (isWishlisted.value) {
        // [삭제] DELETE 요청
        // API 명세에 따라 Query Param 혹은 Path Variable 확인 필요
        // 여기서는 Query Param 방식(?book_id=...)을 가정
        final res = await http.delete(
          Uri.parse("$baseUrl/wishlist?book_id=$bookId"),
          headers: {"Authorization": "Bearer $token"},
        );

        if (res.statusCode == 200 || res.statusCode == 204) {
          isWishlisted.value = false;
          Get.snackbar("완료", "읽고싶어요에서 제거되었습니다.");
        }
      } else {
        // [추가] POST 요청
        final res = await http.post(
          Uri.parse("$baseUrl/wishlist?book_id=$bookId"), // 이미지 명세 참고: Query Param
          headers: {"Authorization": "Bearer $token"},
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          isWishlisted.value = true;
          Get.snackbar("완료", "읽고싶어요에 추가되었습니다.");
        }
      }
    } catch (e) {
      Get.snackbar("오류", "네트워크 오류가 발생했습니다.");
    }
  }

  // ==========================
  // 📌 코멘트 등록 함수
  // ==========================
  Future<void> submitComment(String content) async {
    if (myRating.value == 0) {
      Get.snackbar("오류", "별점을 먼저 선택해주세요");
      return;
    }

    try {
      final token = box.read("access_token") ?? "";
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/"), // 또는 /upsert
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "book_id": bookId,
          "rating": myRating.value,
          "content": content,
          "is_spoiler": false,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // ✅ 1. UI 상태 즉시 변경 (낙관적 업데이트)
        isCommented.value = true;

        // ⚠️ 문제의 원인: fetchReviews가 내 점수를 0으로 초기화하지 않도록 주의
        // fetchReviews(); <--- 이걸 바로 호출하면 서버 타이밍 이슈로 0점이 될 수 있음

        Get.back(); // 오버레이 닫기
        Get.snackbar("완료", "리뷰가 등록되었습니다.");

        // ✅ 2. 약간의 딜레이 후 서버 데이터 갱신 (선택 사항)
        // Future.delayed(const Duration(milliseconds: 500), () => fetchReviews());

      } else {
        Get.snackbar("오류", "등록 실패 : ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // ==========================
  // 📌 코멘트 버튼 클릭 (Overlay 오픈)
  // ==========================
  Future<void> onWriteReview() async {
    // 1. 이미 내가 쓴 리뷰가 있다면 -> 리뷰 상세 페이지로 이동
    if (isCommented.value && myReviewId != -1) {
      Get.toNamed("/review/detail", arguments: myReviewId);
    }
    // 2. 리뷰가 없다면 -> 작성 시트(Overlay) 띄우기
    else {
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

  // ==========================
  // 📌 더보기 메뉴 오버레이 선택 (Overlay에서 호출)
  // ==========================
  void selectedMenu() async {
    Get.back(); // 오버레이 닫기
    // 다른 팝업 연결
  }
}