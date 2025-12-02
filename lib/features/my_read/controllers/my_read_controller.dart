import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../data/models/user_stats_model.dart';

class MyReadController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 1. User Profile Data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // 2. Activity Stats (평가/코멘트)
  final RxMap<String, int> activityStats = <String, int>{'evaluations': 0, 'comments': 0}.obs;

  // 3. Analytics Data (별점 분포 그래프용)
  RxList<Map<String, dynamic>> ratingDistData = <Map<String, dynamic>>[].obs;

  // 요약 정보
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0".obs;
  RxString readingRate = "0%".obs;

  // 4. 독서 선호 태그
  final List<Map<String, dynamic>> insightTags = [
    {'text': '힐링', 'size': 32.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.0, -0.3)},
    {'text': '스릴', 'size': 26.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.4, 0.4)},
    {'text': '코미디', 'size': 18.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.5, -0.6)},
    {'text': '추리', 'size': 18.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.6, 0.1)},
    {'text': '감동', 'size': 16.0, 'color': 0xFF89C99C, 'align': const Alignment(-0.2, 0.5)},
    {'text': '깊이', 'size': 16.0, 'color': 0xFF89C99C, 'align': const Alignment(0.7, 0.7)},
    {'text': '성장', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.6, -0.4)},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMyReadData();
  }

  void fetchMyReadData() async {
    String? token = box.read('access_token');
    if (token == null) return;

    await Future.wait([
      _fetchUserProfile(token),
      _fetchStats(token),
    ]);
  }

  Future<void> _fetchUserProfile(String token) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auth/me'), headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        userProfile.value = jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("User Profile Error: $e");
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

        // ✅ [수정] 5점부터 1점까지 고정 색상 적용 (TasteAnalysis와 동일하게)
        // 5점: 가장 진함(0xFF43A047) ~ 1점: 가장 연함(0xFFC8E6C9)
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
            "color": colorMap[i] // 점수별 고정 색상 사용
          });
        }
        ratingDistData.value = tempDist;
      }
    } catch (e) {
      print("My Stats Error: $e");
    }
  }
}