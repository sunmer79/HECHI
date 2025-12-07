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

  // 1. 별점 분포
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

  // 2. 선호 태그 (API 연동)
  RxList<Map<String, dynamic>> tags = <Map<String, dynamic>>[].obs;

  // 3. 선호 장르
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
        _fetchInsightTags(token), // ✅ 태그 API 호출 추가
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

  // 통계 API (기존 로직 유지)
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

      // 경제/경영 합치기 로직
      List<GenreStat> sourceList = stats.subGenres.isNotEmpty ? stats.subGenres : stats.topLevelGenres;
      List<GenreStat> mergedList = [];
      int bizEcoCount = 0;
      double bizEcoTotalScore = 0.0;
      bool hasBizEco = false;

      for (var genre in sourceList) {
        if (genre.name.contains('경제') || genre.name.contains('경영')) {
          hasBizEco = true;
          bizEcoCount += genre.reviewCount;
          bizEcoTotalScore += (genre.average5 * genre.reviewCount);
        } else {
          mergedList.add(genre);
        }
      }

      if (hasBizEco && bizEcoCount > 0) {
        mergedList.add(GenreStat(
          name: '경제/경영',
          reviewCount: bizEcoCount,
          average5: bizEcoTotalScore / bizEcoCount,
        ));
      }

      genreRankings.value = mergedList;
      genreRankings.sort((a, b) => b.average5.compareTo(a.average5));
    }
  }

  Future<void> _fetchInsightTags(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-insights');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final insightData = UserInsightResponse.fromJson(json);

        if (insightData.tags.isEmpty) return;

        // 화면 배치 위치 (워드 클라우드 형태)
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

        // 가중치 높은 순으로 정렬
        var sortedTags = insightData.tags;
        sortedTags.sort((a, b) => b.weight.compareTo(a.weight)); // 내림차순 정렬

        // 상위 7개만 선택 (화면에 꽉 차지 않게)
        var topTags = sortedTags.take(positions.length).toList();

        for (int i = 0; i < topTags.length; i++) {
          final tag = topTags[i];
          final weight = tag.weight; // 0.0 ~ 1.0 (가중치)

          // 1️⃣ 글자 크기: 가중치에 비례하여 14 ~ 34 사이로 설정
          // (weight * 20) -> 0 ~ 20 추가됨
          final double size = 14.0 + (weight * 20.0);

          // 2️⃣ 색상: 가중치에 따라 5단계로 나눔 (진한 초록 -> 연한 초록)
          int color;
          if (weight > 0.8) {
            color = 0xFF2E7D32; // 가장 진함 (중요)
          } else if (weight > 0.6) {
            color = 0xFF43A047; // 조금 진함
          } else if (weight > 0.4) {
            color = 0xFF66BB6A; // 중간 (메인)
          } else if (weight > 0.2) {
            color = 0xFF81C784; // 연함
          } else {
            color = 0xFFA5D6A7; // 가장 연함
          }

          newTags.add({
            'text': tag.label,
            'size': size,
            'color': color,
            'align': positions[i],
          });
        }

        tags.value = newTags;
      }
    } catch (e) {
      print("Tag fetch error: $e");
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