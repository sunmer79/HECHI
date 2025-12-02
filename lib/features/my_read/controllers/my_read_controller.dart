import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/my_read_model.dart';
import 'dart:math';

class MyReadController extends GetxController {
  // 1. User Profile Data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // 2. Activity Stats (평가/코멘트)
  final RxMap<String, int> activityStats = <String, int>{}.obs;

  // 3. Analytics Data (JSON Map으로 유지 - API 연동 전까지)
  final RxMap<String, dynamic> analyticsData = <String, dynamic>{}.obs;

  // 4. User Insights (나의 독서 - 취향 분석 데이터)
  final RxMap<String, dynamic> userInsights = <String, dynamic>{}.obs;

  // 5. 독서 선호 태그 (위치 및 크기 조정)
  final List<Map<String, dynamic>> insightTags = [
    // ✅ [수정] 태그 내용: 카테고리(소설) 대신 장르/느낌 태그(코미디, 추리) 사용
    // ✅ [수정] Alignment: 간격을 줄이기 위해 좌표를 0.5 이내로 조정하여 중앙에 밀집시킴
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
    // 실제 API 호출 로직이 들어갈 곳
    _loadDummyData();
  }

  void _loadDummyData() {
    // [API] GET /auth/me
    userProfile.value = {
      "nickname": "HECHI",
      "email": "user@example.com",
    };

    // [API] GET /analytics/my-stats
    // 데이터가 없는 상태를 가정하여 모든 count를 0으로 설정
    List<Map<String, dynamic>> distribution = [
      {"rating": 5, "count": 0},
      {"rating": 4, "count": 0},
      {"rating": 3, "count": 0},
      {"rating": 2, "count": 0},
      {"rating": 1, "count": 0},
    ];

    int totalReviews = distribution.fold(0, (sum, item) => sum + item['count'] as int);

    // ✅ [수정] Reading Rate (average_100) 및 모든 통계 수정
    // 총 리뷰 개수(totalReviews)가 0이면 모든 비율/평균을 0으로 설정하여 일관성을 맞춥니다.
    double readingRate = (totalReviews > 0) ? 88.0 : 0.0;

    Map<String, dynamic> statsResponse = {
      "rating_distribution": distribution,
      "rating_summary": {
        "average_5": (totalReviews > 0) ? 4.5 : 0.0,
        "average_100": readingRate, // ➡️ 데이터가 0이므로 0.0%로 표시
        "total_reviews": totalReviews,
        "most_frequent_rating": (totalReviews > 0) ? 5 : 0,
      },
      "reading_time": {
        "total_seconds": 0,
        "human": "0시간",
      },
    };

    analyticsData.value = statsResponse;

    // [API 매핑] 활동 요약
    activityStats.value = {
      "evaluations": totalReviews,
      "comments": 0,
    };

    userInsights.value = {
      "analysis": "분석 데이터가 부족하여 취향 분석이 어렵습니다.",
      "tags": []
    };
  }

  // 별점 비율 계산 Helper (MyReadView의 그래프에 사용됨)
  double getRatingRatio(int rating) {
    // ✅ [수정] total이 0일 때 나누기 오류 방지
    if (analyticsData.isEmpty) return 0.0;

    List distribution = analyticsData['rating_distribution'] ?? [];
    Map<String, dynamic>? summary = analyticsData['rating_summary'];
    int total = summary?['total_reviews'] ?? 1;

    if (total == 0) return 0.0;

    var target = distribution.firstWhere(
          (e) => e['rating'] == rating,
      orElse: () => {"count": 0},
    );

    return (target['count'] as int) / total;
  }
}