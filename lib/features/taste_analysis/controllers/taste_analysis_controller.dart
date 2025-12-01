import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasteAnalysisController extends GetxController {
  // 1. [API Data] GET /analytics/my-stats
  final RxMap<String, dynamic> analyticsData = <String, dynamic>{}.obs;

  // 2. [API Data] GET /analytics/my-insights
  final RxMap<String, dynamic> insightData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyApiData();
  }

  void _loadDummyApiData() {
    // [API] GET /analytics/my-stats Response
    analyticsData.value = {
      "rating_distribution": [
        {"rating": 5, "count": 8},
        {"rating": 4, "count": 6},
        {"rating": 3, "count": 4},
        {"rating": 2, "count": 3},
        {"rating": 1, "count": 1},
      ],
      "rating_summary": {
        "average_5": 4.5,
        "total_reviews": 28,
        "average_100": 88.0,
        "most_frequent_rating": 4.0,
      },
      "reading_time": {
        "total_seconds": 187200,
        "human": "52",
      },
      "category_distribution": [
        {"name": "소설", "count": 8},
        {"name": "시", "count": 5},
        {"name": "에세이", "count": 11},
        {"name": "만화", "count": 6},
      ],
      "top_level_genres": [
        {"name": "코미디", "review_count": 5, "average_100": 93},
        {"name": "가족", "review_count": 4, "average_100": 96},
        {"name": "미스터리", "review_count": 3, "average_100": 91},
        {"name": "추리", "review_count": 2, "average_100": 92},
        {"name": "스릴러", "review_count": 2, "average_100": 87},
        {"name": "공포", "review_count": 2, "average_100": 88},
        {"name": "SF", "review_count": 2, "average_100": 89},
        {"name": "판타지", "review_count": 2, "average_100": 92},
      ],
    };

    // [API] GET /analytics/my-insights Response
    insightData.value = {
      "analysis": "당신은 힐링과 감동을 주는 이야기를 선호하는 독서가입니다.",
      "tags": ["힐링", "스릴 넘친", "절망", "블랙 코미디", "감동적인", "깊이 있는", "소설"]
    };
  }

  // --- UI Getters ---

  // 1. 평가 수
  Map<String, int> get countStats {
    if (analyticsData.isEmpty) return {'소설': 0, '시': 0, '에세이': 0, '만화': 0};
    List list = analyticsData['category_distribution'] ?? [];
    Map<String, int> result = {};
    for (var item in list) {
      result[item['name']] = item['count'];
    }
    if (result.isEmpty) return {'소설': 0, '시': 0, '에세이': 0, '만화': 0};
    return result;
  }

  // 2. 별점 분포
  List<Map<String, dynamic>> get starRatingDistribution {
    if (analyticsData.isEmpty) return [];

    List rawList = analyticsData['rating_distribution'] ?? [];
    int total = int.tryParse(totalReviews) ?? 1;
    if (total == 0) total = 1;

    List<int> scores = [5, 4, 3, 2, 1];
    final colors = {
      5: 0xFF43A047, 4: 0xFF66BB6A, 3: 0xFF81C784,
      2: 0xFFA5D6A7, 1: 0xFFC8E6C9
    };

    return scores.map((score) {
      var item = rawList.firstWhere(
              (e) => e['rating'] == score,
          orElse: () => {'count': 0}
      );
      int count = item['count'];
      double ratio = count / total;

      return {
        'score': score,
        'ratio': ratio,
        'color': colors[score]
      };
    }).toList();
  }

  // 요약 정보 Getters
  String get averageRating => (analyticsData['rating_summary']?['average_5'] ?? 0.0).toString();
  String get totalReviews => (analyticsData['rating_summary']?['total_reviews'] ?? 0).toString();
  String get readingRate => "${(analyticsData['rating_summary']?['average_100'] ?? 0)}%";
  String get mostGivenRating => (analyticsData['rating_summary']?['most_frequent_rating'] ?? 0.0).toString();
  String get totalReadingTime => (analyticsData['reading_time']?['human'] ?? "0").toString();

  // 3. 선호 태그
  List<Map<String, dynamic>> get tags {
    List rawTags = insightData['tags'] ?? [];

    final presets = [
      {'size': 32.0, 'color': 0xFF4DB56C, 'align': Alignment.center},
      {'size': 26.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.5, 0.5)},
      {'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.6, -0.5)},
      {'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.8, 0.2)},
      {'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(-0.3, 0.6)},
      {'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.8, 0.8)},
      {'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.7, -0.6)},
    ];

    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < rawTags.length; i++) {
      if (i >= presets.length) break;
      String text = "";
      if (rawTags[i] is String) {
        text = rawTags[i];
      } else if (rawTags[i] is Map) {
        text = rawTags[i]['label'] ?? rawTags[i]['text'] ?? "";
      }
      result.add({'text': text, ...presets[i]});
    }
    return result;
  }

  // 4. 선호 장르
  List<Map<String, dynamic>> get genreRankings {
    if (analyticsData.isEmpty) return [];
    List rawList = analyticsData['top_level_genres'] ?? [];

    return rawList.map((g) {
      return {
        'genre': g['name'],
        'score': g['average_100'],
        'count': g['review_count']
      };
    }).toList();
  }
}