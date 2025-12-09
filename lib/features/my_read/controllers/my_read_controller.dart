import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

// 모델 경로가 맞는지 확인해주세요
import '../../../data/models/user_stats_model.dart';
import '../../../app/controllers/app_controller.dart';

class MyReadController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // AppController 연결 (전역 상태)
  RxMap<String, dynamic> get userProfile => Get.find<AppController>().userProfile;
  RxString get description => Get.find<AppController>().description;

  // ------------------------------------------------------------------------
  // 통계 관련 변수
  // ------------------------------------------------------------------------
  final RxMap<String, int> activityStats = <String, int>{'evaluations': 0, 'comments': 0}.obs;

  // 취향 분석 - 별점 분포 데이터 (그래프용)
  RxList<Map<String, dynamic>> ratingDistData = <Map<String, dynamic>>[].obs;

  // 취향 분석 - 하단 통계 수치
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0.0".obs;
  RxString readingRate = "0%".obs;

  // ✅ [신규] 많이 준 별점
  RxString mostGivenRating = "0.0".obs;

  // 태그 클라우드 데이터
  RxList<Map<String, dynamic>> insightTags = <Map<String, dynamic>>[].obs;

  // 캘린더 관련 변수
  RxInt currentYear = DateTime.now().year.obs;
  RxInt currentMonth = DateTime.now().month.obs;
  RxMap<int, String> calendarBooks = <int, String>{}.obs;

  // ------------------------------------------------------------------------
  // Lifecycle Methods
  // ------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    // ✅ 화면 진입 시 즉시 데이터 로드 (onReady 중복 제거됨)
    fetchMyReadData();
  }

  // ------------------------------------------------------------------------
  // Data Fetching Logic
  // ------------------------------------------------------------------------

  /// 전체 데이터 새로고침 (프로필, 통계, 태그, 캘린더)
  Future<void> fetchMyReadData() async {
    String? token = box.read('access_token');
    if (token == null) return;

    // 프로필 정보 갱신 (AppController 위임)
    Get.find<AppController>().fetchUserProfile();

    // 나머지 데이터 병렬 호출
    await Future.wait([
      _fetchStats(token),
      _fetchInsightTags(token),
      fetchCalendarData(token),
    ]);
  }

  /// 프로필 업데이트 요청 처리
  void updateProfile(String newName, String newDesc) {
    Get.find<AppController>().updateUserProfile(newName, newDesc);
    Get.back(); // 수정 페이지 닫기
    Get.snackbar("성공", "프로필이 변경되었습니다.", backgroundColor: Colors.white);
  }

  /// 캘린더 월 변경
  void changeMonth(int offset) {
    DateTime newDate = DateTime(currentYear.value, currentMonth.value + offset);
    currentYear.value = newDate.year;
    currentMonth.value = newDate.month;

    String? token = box.read('access_token');
    if (token != null) {
      fetchCalendarData(token);
    }
  }

  /// 캘린더 데이터(월별 독서 기록) 가져오기
  Future<void> fetchCalendarData(String token) async {
    final url = Uri.parse('$baseUrl/analytics/calendar-month?year=${currentYear.value}&month=${currentMonth.value}');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        Map<int, String> newBooks = {};
        List days = data['days'] ?? [];

        for (var dayData in days) {
          String dateStr = dayData['date'];
          DateTime date = DateTime.parse(dateStr);
          List items = dayData['items'] ?? [];

          if (items.isNotEmpty) {
            // 첫 번째 아이템의 썸네일 사용
            String thumbnail = items[0]['thumbnail'] ?? "";
            if (thumbnail.isNotEmpty) {
              newBooks[date.day] = thumbnail;
            }
          }
        }
        calendarBooks.value = newBooks;
      }
    } catch (e) {
      print("Calendar fetch error: $e");
    }
  }

  /// 통계 및 취향 분석 데이터 가져오기
  Future<void> _fetchStats(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/analytics/my-stats'), headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final stats = UserStatsResponse.fromJson(json);

        // 상단 활동 통계 업데이트
        activityStats['evaluations'] = stats.ratingSummary.totalReviews;
        // ⚠️ 현재 API 모델상 코멘트 수가 별도로 없다면 totalReviews를 같이 쓰거나,
        // UserStatsResponse에 별도 필드가 있다면 그것으로 수정해야 합니다.
        activityStats['comments'] = stats.ratingSummary.totalReviews;

        // 하단 통계 수치 업데이트
        averageRating.value = stats.ratingSummary.average5.toStringAsFixed(1);
        totalReviews.value = stats.ratingSummary.totalReviews.toString();
        readingRate.value = "${stats.ratingSummary.average100}%";

        // ✅ [신규] 많이 준 별점 업데이트
        mostGivenRating.value = stats.ratingSummary.mostFrequentRating.toStringAsFixed(1);

        // 별점 분포 그래프 데이터 가공
        int maxCount = 0;
        for (var d in stats.ratingDistribution) {
          if (d.count > maxCount) maxCount = d.count;
        }

        final colorMap = {
          5: 0xFF43A047,
          4: 0xFF66BB6A,
          3: 0xFF81C784,
          2: 0xFFA5D6A7,
          1: 0xFFC8E6C9,
        };

        List<Map<String, dynamic>> tempDist = [];
        // 5점부터 1점까지 역순으로 리스트 생성
        for (int i = 5; i >= 1; i--) {
          var apiData = stats.ratingDistribution.firstWhere(
                (d) => d.rating == i,
            orElse: () => RatingDist(rating: i, count: 0),
          );

          // 최대값 기준 비율 계산 (그래프 너비용)
          double ratio = maxCount > 0 ? (apiData.count / maxCount) : 0.0;

          tempDist.add({
            "score": i,
            "ratio": ratio,
            "color": colorMap[i]
          });
        }
        ratingDistData.value = tempDist;
      }
    } catch (e) {
      print("My Stats Error: $e");
    }
  }

  /// 인사이트 태그(태그 클라우드) 가져오기
  Future<void> _fetchInsightTags(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-insights');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final insightData = UserInsightResponse.fromJson(json);

        if (insightData.tags.isEmpty) {
          insightTags.clear();
          return;
        }

        // 태그 클라우드 배치 좌표 (고정값)
        final List<Alignment> positions = [
          const Alignment(0.0, -0.2), const Alignment(0.6, 0.4), const Alignment(-0.6, -0.5),
          const Alignment(-0.5, 0.5), const Alignment(0.7, -0.6), const Alignment(0.1, 0.8),
          const Alignment(-0.8, 0.0),
        ];

        List<Map<String, dynamic>> newTags = [];
        var sortedTags = insightData.tags;
        // 가중치(weight) 순으로 정렬하여 상위 태그 추출
        sortedTags.sort((a, b) => b.weight.compareTo(a.weight));
        var topTags = sortedTags.take(positions.length).toList();

        for (int i = 0; i < topTags.length; i++) {
          final tag = topTags[i];
          // 순위에 따라 크기 및 색상 차등 적용
          final double size = 40.0 - (i * 4.0);

          int color;
          if (i == 0) { color = 0xFF2E7D32; }
          else if (i == 1) { color = 0xFF388E3C; }
          else if (i == 2) { color = 0xFF43A047; }
          else if (i == 3) { color = 0xFF4DB56C; }
          else if (i == 4) { color = 0xFF66BB6A; }
          else { color = 0xFF81C784; }

          newTags.add({
            'text': tag.label,
            'size': size,
            'color': color,
            'align': positions[i],
          });
        }
        insightTags.value = newTags;
      }
    } catch (e) {
      print("Tag fetch error: $e");
    }
  }
}