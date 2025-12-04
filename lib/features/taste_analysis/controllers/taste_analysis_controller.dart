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

  // 0. 사용자 정보
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

  // 요약 정보
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0".obs;
  RxString readingRate = "0%".obs;
  RxString mostGivenRating = "0.0".obs;
  RxString totalReadingTime = "0".obs;

  // 3. 선호 태그
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
        _fetchUserProfile(token),
        _fetchMyStats(token),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
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

      // --- 평가 수 매핑 (스마트 분류) ---
      var newCounts = {'소설': 0, '시': 0, '에세이': 0, '만화': 0};

      print("🔍 [DEBUG] 실제 API 장르 목록:");
      for (var genre in stats.topLevelGenres) {
        print(" - ${genre.name} (${genre.reviewCount})");

        if (genre.name.contains('소설') || genre.name.contains('Novel') || genre.name.contains('Fiction')) {
          newCounts['소설'] = (newCounts['소설'] ?? 0) + genre.reviewCount;
        }
        else if (genre.name.contains('시') || genre.name.contains('Poetry')) {
          newCounts['시'] = (newCounts['시'] ?? 0) + genre.reviewCount;
        }
        else if (genre.name.contains('에세이') || genre.name.contains('산문') || genre.name.contains('Essay')) {
          newCounts['에세이'] = (newCounts['에세이'] ?? 0) + genre.reviewCount;
        }
        else if (genre.name.contains('만화') || genre.name.contains('웹툰') || genre.name.contains('Comics')) {
          newCounts['만화'] = (newCounts['만화'] ?? 0) + genre.reviewCount;
        }
      }
      countStats.value = newCounts;

      // --- [핵심 수정] 경제/경영 합치기 및 장르 리스트 정리 ---
      List<GenreStat> sourceList = stats.subGenres.isNotEmpty ? stats.subGenres : stats.topLevelGenres;
      List<GenreStat> mergedList = [];

      int bizEcoCount = 0;
      double bizEcoTotalScore = 0.0;
      bool hasBizEco = false;

      for (var genre in sourceList) {
        // 경제나 경영이 포함된 경우 합산 로직
        if (genre.name.contains('경제') || genre.name.contains('경영')) {
          hasBizEco = true;
          bizEcoCount += genre.reviewCount;
          // 가중 평균을 위해 (평점 * 개수)를 더해둠
          bizEcoTotalScore += (genre.average5 * genre.reviewCount);
        } else {
          // 나머지는 그대로 리스트에 추가
          mergedList.add(genre);
        }
      }

      // 합쳐진 '경제/경영' 항목 생성 및 추가
      if (hasBizEco && bizEcoCount > 0) {
        mergedList.add(GenreStat(
          name: '경제/경영',
          reviewCount: bizEcoCount,
          average5: bizEcoTotalScore / bizEcoCount, // 가중 평균 계산
        ));
      }

      genreRankings.value = mergedList;
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