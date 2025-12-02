import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../data/models/user_stats_model.dart';

class TasteAnalysisController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  RxBool isLoading = true.obs;

  // 0. 사용자 정보 (닉네임 표시용)
  RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // 1. 평가 수
  RxMap<String, int> countStats = {'소설': 0, '시': 0, '에세이': 0, '만화': 0}.obs;

  // 2. 별점 분포
  RxList<Map<String, dynamic>> starRatingDistribution = <Map<String, dynamic>>[
    {'score': 5, 'ratio': 0.0, 'color': 0xFF43A047},
    {'score': 4, 'ratio': 0.0, 'color': 0xFF66BB6A},
    {'score': 3, 'ratio': 0.0, 'color': 0xFF81C784},
    {'score': 2, 'ratio': 0.0, 'color': 0xFFA5D6A7},
    {'score': 1, 'ratio': 0.0, 'color': 0xFFC8E6C9},
  ].obs;

  // 요약
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0".obs;
  RxString readingRate = "0%".obs;
  RxString mostGivenRating = "0.0".obs;
  RxString totalReadingTime = "0".obs;

  // 3. 선호 태그 (더미)
  RxList<Map<String, dynamic>> tags = <Map<String, dynamic>>[
    {'text': '힐링', 'size': 32.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.0, -0.3)},
    {'text': '스릴', 'size': 26.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.4, 0.4)},
    {'text': '코미디', 'size': 18.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.5, -0.6)},
    {'text': '추리', 'size': 18.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.6, 0.1)},
    {'text': '감동', 'size': 16.0, 'color': 0xFF89C99C, 'align': const Alignment(-0.2, 0.5)},
    {'text': '깊이', 'size': 16.0, 'color': 0xFF89C99C, 'align': const Alignment(0.7, 0.7)},
    {'text': '성장', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.6, -0.4)},
  ].obs;

  // 4. 선호 장르
  RxList<GenreStat> genreRankings = <GenreStat>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    String? token = box.read('access_token');
    if (token == null) {
      isLoading.value = false;
      return;
    }

    try {
      await Future.wait([
        _fetchUserProfile(token),   // [추가] 닉네임 가져오기
        _fetchCategoryCounts(token),
        _fetchMyStats(token),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // [API] 유저 정보 가져오기 (닉네임)
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

  Future<void> _fetchCategoryCounts(String token) async {
    // API에 요청하는 카테고리 문자열이 DB와 정확히 일치해야 0이 안 나옴
    final categories = ['소설', '시', '에세이', '만화'];
    final newCounts = <String, int>{};

    final futures = categories.map((category) async {
      try {
        final encodedCategory = Uri.encodeComponent(category);
        final url = Uri.parse('$baseUrl/library/?shelf=rated&categories_in=$encodedCategory&limit=1');

        final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          return MapEntry(category, data['total'] as int);
        }
      } catch (e) {
        print("카테고리 조회 실패 ($category): $e");
      }
      return MapEntry(category, 0);
    });

    final results = await Future.wait(futures);
    for (var entry in results) {
      newCounts[entry.key] = entry.value;
    }
    countStats.value = newCounts;
  }

  Future<void> _fetchMyStats(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-stats');
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final stats = UserStatsResponse.fromJson(json);

      averageRating.value = stats.ratingSummary.average5.toStringAsFixed(1);
      totalReviews.value = stats.ratingSummary.totalReviews.toString();
      readingRate.value = "${stats.ratingSummary.average100}%";
      mostGivenRating.value = stats.ratingSummary.mostFrequentRating.toStringAsFixed(1);

      String timeText = stats.readingTime.human;
      totalReadingTime.value = timeText.replaceAll("시간", "").trim();

      _updateDistribution(stats.ratingDistribution);

      // [변경] 장르 데이터: subGenres(로맨스, 추리 등)가 있으면 우선 사용, 없으면 topLevel(소설 등) 사용
      if (stats.subGenres.isNotEmpty) {
        genreRankings.value = stats.subGenres;
      } else {
        genreRankings.value = stats.topLevelGenres;
      }
      // 점수 높은 순 정렬
      genreRankings.sort((a, b) => b.average5.compareTo(a.average5));
    }
  }

  void _updateDistribution(List<RatingDist> distData) {
    int maxCount = 0;
    for (var d in distData) {
      if (d.count > maxCount) maxCount = d.count;
    }

    var newDist = <Map<String, dynamic>>[];
    for (var item in starRatingDistribution) {
      int score = item['score'];
      var apiData = distData.firstWhere(
            (d) => d.rating == score,
        orElse: () => RatingDist(rating: score, count: 0),
      );

      double ratio = maxCount > 0 ? (apiData.count / maxCount) : 0.0;
      newDist.add({'score': score, 'ratio': ratio, 'color': item['color']});
    }
    starRatingDistribution.value = newDist;
  }
}