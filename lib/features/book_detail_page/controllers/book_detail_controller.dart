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

  // 라우트에서 전달받는 bookId (없으면 1)
  final int bookId = Get.arguments ?? 1;

  // ====== 공통 상태 ======
  final RxBool isLoading = true.obs;

  // 책 정보
  final RxMap book = {}.obs;

  // 리뷰 리스트
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  // 평점 히스토그램 최대값
  final RxInt maxRatingCount = 1.obs;

  // 화면 상단 별점(내 별점)
  final RxDouble myRating = 0.0.obs;

  // 버튼 상태
  bool get isWishlisted => readingStatus.value == 'wishlist';
  bool get isReadingOrCompleted => ['reading', 'completed'].contains(readingStatus.value);
  final RxBool isCommented = false.obs;

  // "", "reading", "finished" 등
  final RxString readingStatus = "".obs;

  // 내가 방금/예전에 쓴 리뷰의 id (상세 페이지 이동용)
  int myReviewId = -1;

  @override
  void onInit() {
    super.onInit();
    fetchBookDetail();
    fetchReviews();
    fetchReadingStatus();
  }

// 서버로 보낼 shelf key 변환
  String _convertToShelfKey(String status) {
    // none일 경우 API 스펙에 맞게 빈 문자열이나 "none" 등을 전송 (API 문서 확인 필요)
    // 여기서는 예시로 status 그대로 전송하되, 로직에 따라 매핑
    return status;
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
  // ==========================
  Future<void> fetchReadingStatus() async {
    try {
      final token = box.read('access_token') ?? '';
      if (token.isEmpty) {
        print("토큰 발급 실패");
        return;
      }

      final res = await http.get(
        Uri.parse("$baseUrl/reading-status/summary/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        // 서버에서 오는 상태값을 그대로 적용
        readingStatus.value = decoded["status"] ?? "none";
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
  Future<void> _changeStatus(String targetStatus) async {
    final token = box.read('access_token') ?? '';
    if (token.isEmpty) {
      Get.snackbar("오류", "로그인이 필요합니다.");
      return;
    }

    final String prevStatus = readingStatus.value;
    String newStatus = targetStatus;

    // ✅ 토글 로직: 이미 해당 상태라면 'none'으로 해제
    if (prevStatus == targetStatus) {
      newStatus = "none";
    }

    readingStatus.value = newStatus;

    // 2. 서버 통신
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/reading-status/update"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "book_id": bookId,
          "status": newStatus // none, wishlist, reading, completed 등
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        String msg = "";
        switch (newStatus) {
          case "wishlist": msg = "'읽고싶어요'에 등록되었습니다."; break;
          case "reading": msg = "'읽는 중'으로 변경되었습니다."; break;
          case "completed": msg = "완독 처리되었습니다."; break;
          case "none": msg = "상태가 해제되었습니다."; break;
        }
        if (msg.isNotEmpty) {
          Get.snackbar("완료", msg, snackPosition: SnackPosition.TOP);
        }
      } else {
        throw Exception("Status code: ${res.statusCode}");
      }
    } catch (e) {
      // 실패 시 롤백
      readingStatus.value = prevStatus;
      Get.snackbar("오류", "상태 변경 실패: $e");
    }
  }

  // ==========================
  // 📌 읽고싶어요 토글
  // ==========================
  Future<void> onWantToRead() async{
    await _changeStatus("wishlist");
  }

  // ==========================
  // 📌 코멘트 등록 함수
  // ==========================
  Future<void> submitComment(String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar("오류", "내용을 입력해주세요.", snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      final token = box.read('access_token') ?? '';
      final res = await http.post(
        Uri.parse("$baseUrl/reviews/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "book_id": bookId,
          "rating": myRating.value.toInt(),
          "content": content,
          "is_spoiler": false,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        isCommented.value = true;
        await fetchReviews(); // 목록 갱신
        Get.back(); // 오버레이 닫기
        Get.snackbar("완료", "코멘트가 등록되었습니다.");
      } else {
        Get.snackbar("오류", "코멘트 등록 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Review POST Error: $e");
      Get.snackbar("오류", "네트워크 오류가 발생했습니다.");
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
  // 📌 독서 상태 오버레이 선택 (Overlay에서 호출)
  // ==========================
  Future<void> updateReadingStatus(String status) async {
    Get.back(); // 오버레이 닫기
    await _changeStatus(status);
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