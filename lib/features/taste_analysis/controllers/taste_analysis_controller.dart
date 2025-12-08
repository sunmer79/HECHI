import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../data/models/user_stats_model.dart';
import '../../../app/controllers/app_controller.dart';

class TasteAnalysisController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  RxBool isLoading = true.obs;

  RxMap<String, dynamic> get userProfile => Get.find<AppController>().userProfile;

  RxList<Map<String, dynamic>> starRatingDistribution = <Map<String, dynamic>>[
    {'score': 5, 'ratio': 0.0, 'color': 0xFF43A047},
    {'score': 4, 'ratio': 0.0, 'color': 0xFF66BB6A},
    {'score': 3, 'ratio': 0.0, 'color': 0xFF81C784},
    {'score': 2, 'ratio': 0.0, 'color': 0xFFA5D6A7},
    {'score': 1, 'ratio': 0.0, 'color': 0xFFC8E6C9},
  ].obs;
  RxString averageRating = "0.0".obs;
  RxString totalReviews = "0.0".obs;
  RxString readingRate = "0%".obs;
  RxString mostGivenRating = "0.0".obs;
  RxString totalReadingTime = "0.0".obs;
  RxList<Map<String, dynamic>> tags = <Map<String, dynamic>>[].obs;
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
        _fetchMyStats(token),
        _fetchInsightTags(token),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
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

  // ✅ [수정] 태그 위치 간격 넓힘
  Future<void> _fetchInsightTags(String token) async {
    final url = Uri.parse('$baseUrl/analytics/my-insights');
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final insightData = UserInsightResponse.fromJson(json);

        if (insightData.tags.isEmpty) return;

        // ✅ 위치 좌표를 더 바깥쪽(1.0에 가깝게)으로 수정하여 간격 확보
        final List<Alignment> positions = [
          const Alignment(0.0, -0.3),  // 1등: 중앙 상단 (조금 더 위로)
          const Alignment(0.85, 0.6),  // 2등: 우측 하단 (더 끝으로)
          const Alignment(-0.85, -0.7),// 3등: 좌측 상단 (더 끝으로)
          const Alignment(-0.75, 0.75),// 4등: 좌측 하단 (더 끝으로)
          const Alignment(0.9, -0.6),  // 5등: 우측 상단 (더 끝으로)
          const Alignment(0.0, 0.9),   // 6등: 중앙 하단 (더 아래로)
          const Alignment(-0.9, 0.1),  // 7등: 좌측 중앙 (더 끝으로)
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
        tags.value = newTags;
      }
    } catch (e) {
      print("Tag fetch error: $e");
    }
  }
}