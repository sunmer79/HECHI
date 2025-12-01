import 'package:get/get.dart';

class MyReadController extends GetxController {
  // 1. User Profile Data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // 2. Activity Stats (평가/코멘트)
  final RxMap<String, int> activityStats = <String, int>{}.obs;

  // 3. Analytics Data
  final RxMap<String, dynamic> analyticsData = <String, dynamic>{}.obs;

  // 4. User Insights
  final RxMap<String, dynamic> userInsights = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    // [API] GET /auth/me
    userProfile.value = {
      "nickname": "HECHI",
      "email": "user@example.com",
    };

    // [API] GET /analytics/my-stats
    // ✅ [오류 해결] 타입을 명시적으로 Map<String, dynamic>으로 선언
    Map<String, dynamic> statsResponse = {
      "rating_distribution": [
        {"rating": 5, "count": 15},
        {"rating": 4, "count": 8},
        {"rating": 3, "count": 3},
        {"rating": 2, "count": 2},
        {"rating": 1, "count": 0},
      ],
      "rating_summary": {
        "average_5": 4.5,
        "average_100": 88.0,
        "total_reviews": 28,
        "most_frequent_rating": 5,
      },
      "reading_time": {
        "total_seconds": 187200,
        "human": "52",
      },
    };

    analyticsData.value = statsResponse;

    // [API 매핑] 활동 요약
    activityStats.value = {
      // ✅ [오류 해결] 이제 statsResponse가 Map임을 알기 때문에 접근 가능
      "evaluations": (statsResponse['rating_summary']?['total_reviews'] as int?) ?? 0,
      "comments": 18,
    };

    // [API] GET /analytics/my-insights
    userInsights.value = {
      "analysis": "당신은 힐링과 감동을 주는 이야기를 선호하는 독서가입니다.",
      "tags": [
        "힐링", "성장", "가족", "판타지", "철학적인"
      ]
    };
  }

  // 별점 비율 계산 Helper
  double getRatingRatio(int rating) {
    if (analyticsData.isEmpty) return 0.0;

    List distribution = analyticsData['rating_distribution'] ?? [];
    Map<String, dynamic>? summary = analyticsData['rating_summary'];
    int total = summary?['total_reviews'] ?? 1;

    var target = distribution.firstWhere(
          (e) => e['rating'] == rating,
      orElse: () => {"count": 0},
    );

    return (target['count'] as int) / total;
  }
}