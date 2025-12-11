import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../data/models/user_stats_model.dart';
import '../../../app/controllers/app_controller.dart';

class MyReadController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 전역 상태 연결
  RxMap<String, dynamic> get userProfile => Get.find<AppController>().userProfile;
  RxString get description => Get.find<AppController>().description;

  // 통계 변수
  final RxMap<String, int> activityStats = <String, int>{'evaluations': 0, 'comments': 0}.obs;
  RxList<Map<String, dynamic>> ratingDistData = <Map<String, dynamic>>[].obs;

  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0.0".obs;
  RxString readingRate = "0%".obs;
  RxString mostGivenRating = "0.0".obs;

  // 태그 클라우드 데이터
  RxList<Map<String, dynamic>> insightTags = <Map<String, dynamic>>[].obs;

  // 캘린더 관련 변수
  RxInt currentYear = DateTime.now().year.obs;
  RxInt currentMonth = DateTime.now().month.obs;
  RxInt monthlyReadCount = 0.obs; // 이번 달 읽은 권수

  // 1. 달력 그리드용 표지 (Key: 날짜, Value: 썸네일 URL)
  RxMap<int, String> calendarBooks = <int, String>{}.obs;

  // 2. ✅ [추가됨] 바텀 시트용 상세 리스트 (Key: 날짜, Value: 책 정보 리스트)
  RxMap<int, List<dynamic>> dailyBooks = <int, List<dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyReadData();
  }

  Future<void> fetchMyReadData() async {
    String? token = box.read('access_token');
    if (token == null) return;

    Get.find<AppController>().fetchUserProfile();

    await Future.wait([
      _fetchStats(token),
      _fetchInsightTags(token),
      fetchCalendarData(token),
    ]);
  }

  void updateProfile(String newName, String newDesc) {
    Get.find<AppController>().updateUserProfile(newName, newDesc);
    Get.back();
    Get.snackbar("성공", "프로필이 변경되었습니다.", backgroundColor: Colors.white);
  }

  void changeMonth(int offset) {
    DateTime newDate = DateTime(currentYear.value, currentMonth.value + offset);
    currentYear.value = newDate.year;
    currentMonth.value = newDate.month;

    String? token = box.read('access_token');
    if (token != null) {
      fetchCalendarData(token);
    }
  }

  // ✅ [수정됨] 캘린더 데이터 가져오기 (상세 리스트 파싱 추가)
  Future<void> fetchCalendarData(String token) async {
    final queryParams = {
      'year': currentYear.value.toString(),
      'month': currentMonth.value.toString(),
    };

    final url = Uri.parse('$baseUrl/analytics/calendar-month').replace(queryParameters: queryParams);

    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        monthlyReadCount.value = data['total_read_count'] ?? 0;

        Map<int, String> newCovers = {};      // 표지용
        Map<int, List<dynamic>> newDaily = {}; // 상세 리스트용

        List days = data['days'] ?? [];

        for (var dayData in days) {
          try {
            String dateStr = dayData['date'];
            DateTime date = DateTime.parse(dateStr);
            List items = dayData['items'] ?? [];

            if (items.isNotEmpty) {
              // (1) 표지 저장
              String? thumbnail = items[0]['thumbnail'];
              if (thumbnail != null && thumbnail.isNotEmpty) {
                newCovers[date.day] = thumbnail;
              }

              // (2) ✅ 상세 리스트 저장 (바텀 시트용)
              newDaily[date.day] = items;
            }
          } catch (e) {
            print("⚠️ 날짜 파싱 에러: $e");
          }
        }

        // 상태 업데이트
        calendarBooks.value = newCovers;
        dailyBooks.value = newDaily; // ✅ 변수 업데이트

      }
    } catch (e) {
      print("Calendar fetch error: $e");
    }
  }

  Future<void> _fetchStats(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/analytics/my-stats'), headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final stats = UserStatsResponse.fromJson(json);

        activityStats['evaluations'] = stats.ratingSummary.totalReviews;
        activityStats['comments'] = stats.ratingSummary.totalReviews; // API에 코멘트 수가 없다면 리뷰 수와 동일하게 처리 중

        activityStats.refresh();

        averageRating.value = stats.ratingSummary.average5.toStringAsFixed(1);
        totalReviews.value = stats.ratingSummary.totalReviews.toString();
        readingRate.value = "${stats.ratingSummary.average100}%";
        mostGivenRating.value = stats.ratingSummary.mostFrequentRating.toStringAsFixed(1);

        int maxCount = 0;
        for (var d in stats.ratingDistribution) {
          if (d.count > maxCount) maxCount = d.count;
        }

        final colorMap = {
          5: 0xFF43A047, 4: 0xFF66BB6A, 3: 0xFF81C784, 2: 0xFFA5D6A7, 1: 0xFFC8E6C9,
        };

        List<Map<String, dynamic>> tempDist = [];
        for (int i = 5; i >= 1; i--) {
          var apiData = stats.ratingDistribution.firstWhere(
                (d) => d.rating == i,
            orElse: () => RatingDist(rating: i, count: 0),
          );

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

        final List<Alignment> positions = [
          const Alignment(0.0, -0.2), const Alignment(0.6, 0.4), const Alignment(-0.6, -0.5),
          const Alignment(-0.5, 0.5), const Alignment(0.7, -0.6), const Alignment(0.1, 0.8),
          const Alignment(-0.8, 0.0),
        ];

        List<Map<String, dynamic>> newTags = [];
        var sortedTags = insightData.tags;
        sortedTags.sort((a, b) => b.weight.compareTo(a.weight));
        var topTags = sortedTags.take(positions.length).toList();

        for (int i = 0; i < topTags.length; i++) {
          final tag = topTags[i];
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