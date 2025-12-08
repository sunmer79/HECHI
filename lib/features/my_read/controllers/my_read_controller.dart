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

  RxMap<String, dynamic> get userProfile => Get.find<AppController>().userProfile;
  RxString get description => Get.find<AppController>().description;

  final RxMap<String, int> activityStats = <String, int>{'evaluations': 0, 'comments': 0}.obs;
  RxList<Map<String, dynamic>> ratingDistData = <Map<String, dynamic>>[].obs;
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0.0".obs;
  RxString readingRate = "0%".obs;
  RxList<Map<String, dynamic>> insightTags = <Map<String, dynamic>>[].obs;
  RxInt currentYear = DateTime.now().year.obs;
  RxInt currentMonth = DateTime.now().month.obs;
  RxMap<int, String> calendarBooks = <int, String>{}.obs;

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
    Get.find<AppController>().updateLocalProfile(newName, newDesc);
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

  Future<void> _fetchStats(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/analytics/my-stats'), headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final stats = UserStatsResponse.fromJson(json);

        activityStats['evaluations'] = stats.ratingSummary.totalReviews;
        activityStats['comments'] = stats.ratingSummary.totalReviews;

        averageRating.value = stats.ratingSummary.average5.toStringAsFixed(1);
        totalReviews.value = stats.ratingSummary.totalReviews.toString();
        readingRate.value = "${stats.ratingSummary.average100}%";

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

  // ✅ [수정] 태그 위치 간격 넓힘 (TasteAnalysis와 동일)
  Future<void> _fetchInsightTags(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-insights');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final insightData = UserInsightResponse.fromJson(json);

        if (insightData.tags.isEmpty) return;

        // ✅ 위치 좌표를 더 바깥쪽으로 수정하여 간격 확보
        final List<Alignment> positions = [
          const Alignment(0.0, -0.3),  // 1등: 중앙 상단
          const Alignment(0.85, 0.6),  // 2등: 우측 하단 (끝으로)
          const Alignment(-0.85, -0.7),// 3등: 좌측 상단 (끝으로)
          const Alignment(-0.75, 0.75),// 4등: 좌측 하단 (끝으로)
          const Alignment(0.9, -0.6),  // 5등: 우측 상단 (끝으로)
          const Alignment(0.0, 0.9),   // 6등: 중앙 하단 (아래로)
          const Alignment(-0.9, 0.1),  // 7등: 좌측 중앙 (끝으로)
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