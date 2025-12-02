import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class TasteAnalysisController extends GetxController {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";
  final box = GetStorage();

  RxBool isLoading = true.obs;

  // 1. 평가 수 (API 데이터로 갱신)
  RxMap<String, int> countStats = {'소설': 0, '시': 0, '에세이': 0, '만화': 0}.obs;

  // 2. 별점 분포 (API 데이터로 갱신)
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
  RxString readingRate = "0%".obs; // 초기값 0%
  RxString mostGivenRating = "0.0".obs;
  RxString totalReadingTime = "0".obs;

  // 3. 선호 태그
  final List<Map<String, dynamic>> tags = [
    {'text': '힐링', 'size': 32.0, 'color': 0xFF4DB56C, 'align': Alignment.center},
    {'text': '스릴 넘친', 'size': 26.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.5, 0.5)},
    {'text': '절망', 'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.6, -0.5)},
    {'text': '블랙 코미디', 'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.8, 0.2)},
    {'text': '감동적인', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(-0.3, 0.6)},
    {'text': '깊이 있는', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.8, 0.8)},
    {'text': '소설', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.7, -0.6)},
  ];

  // 4. 선호 장르
  RxList<Map<String, dynamic>> genreRankings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    String? token = box.read('access_token');

    if (token == null) {
      // Get.offAllNamed(Routes.login); // 라우트 없어서 주석 처리
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/analytics/my-stats');
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _parseData(data);
      }
    } catch (e) {
      print("통신 에러: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _parseData(Map<String, dynamic> data) {
    // 1. 별점 요약
    final summary = data['rating_summary'] ?? {};
    averageRating.value = (summary['average_5'] ?? 0).toStringAsFixed(1);
    totalReviews.value = (summary['total_reviews'] ?? 0).toString();
    mostGivenRating.value = (summary['most_frequent_rating'] ?? 0).toStringAsFixed(1);

    // ✅ [수정] average_100을 ReadingRate로 사용 (없거나 0이면 0%로 표시)
    int readingRateInt = (summary['average_100'] ?? 0).toInt();
    readingRate.value = "$readingRateInt%";

    // 2. 독서 시간
    final time = data['reading_time'] ?? {};
    totalReadingTime.value = (time['human'] ?? "0").toString().replaceAll("시간", "").trim();

    // 3. 별점 분포 그래프
    final distribution = (data['rating_distribution'] as List? ?? []);
    int maxCount = 0;
    for (var d in distribution) {
      if ((d['count'] ?? 0) > maxCount) maxCount = d['count'];
    }

    var newDist = <Map<String, dynamic>>[];
    for (var item in starRatingDistribution) {
      int score = item['score'];
      var apiData = distribution.firstWhere((d) => d['rating'] == score, orElse: () => {'rating': score, 'count': 0});
      int count = apiData['count'];
      double ratio = maxCount > 0 ? count / maxCount : 0.0;

      newDist.add({'score': score, 'ratio': ratio, 'color': item['color']});
    }
    starRatingDistribution.value = newDist;


    // 4. 선호 장르 & 카테고리 (평가 수)
    final genres = (data['top_level_genres'] as List? ?? []);
    var tempCounts = {'소설': 0, '시': 0, '에세이': 0, '만화': 0};

    for (var g in genres) {
      String name = g['name'] ?? '';
      int count = g['review_count'] ?? 0;
      double score = (g['average_100'] ?? 0).toDouble();

      // 카테고리 매핑 (이름이 일치하면 카운트)
      if (tempCounts.containsKey(name)) {
        tempCounts[name] = count;
      }
    }
    genreRankings.value = genres.map((g) => {
      'genre': g['name'] ?? '',
      'score': (g['average_100'] ?? 0).toInt(),
      'count': g['review_count'] ?? 0
    }).toList();
    countStats.value = tempCounts;
  }
}