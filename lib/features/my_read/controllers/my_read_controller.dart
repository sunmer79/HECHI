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

  // 4. ✅ [수정] 독서 선호 태그 (API 연동을 위해 RxList로 변경)
  RxList<Map<String, dynamic>> insightTags = <Map<String, dynamic>>[].obs;

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
      _fetchInsightTags(token), // ✅ 태그 데이터 호출 추가
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

  // ✅ [신규] 태그 API 연동 로직 (TasteAnalysis와 동일)
  Future<void> _fetchInsightTags(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-insights');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final insightData = UserInsightResponse.fromJson(json);

        if (insightData.tags.isEmpty) return;

        // 화면 배치 위치
        final List<Alignment> positions = [
          const Alignment(0.0, -0.2),  // 중앙 상단 (가장 중요한 태그)
          const Alignment(0.5, 0.3),   // 우측 하단
          const Alignment(-0.5, -0.4), // 좌측 상단
          const Alignment(-0.4, 0.4),  // 좌측 하단
          const Alignment(0.6, -0.5),  // 우측 상단
          const Alignment(0.1, 0.7),   // 중앙 하단
          const Alignment(-0.7, 0.0),  // 좌측 중앙
        ];

        List<Map<String, dynamic>> newTags = [];

        var sortedTags = insightData.tags;
        sortedTags.sort((a, b) => b.weight.compareTo(a.weight));
        var topTags = sortedTags.take(positions.length).toList();

        for (int i = 0; i < topTags.length; i++) {
          final tag = topTags[i];
          final weight = tag.weight;

          // 크기 및 색상 동적 설정
          final double size = 14.0 + (weight * 20.0);

          int color;
          if (weight > 0.8) {
            color = 0xFF2E7D32;
          } else if (weight > 0.6) {
            color = 0xFF43A047;
          } else if (weight > 0.4) {
            color = 0xFF66BB6A;
          } else if (weight > 0.2) {
            color = 0xFF81C784;
          } else {
            color = 0xFFA5D6A7;
          }

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