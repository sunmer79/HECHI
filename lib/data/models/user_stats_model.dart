class UserStatsResponse {
  final List<RatingDist> ratingDistribution;
  final RatingSummary ratingSummary;
  final ReadingTime readingTime;
  final List<GenreStat> topLevelGenres;
  final List<GenreStat> subGenres;

  UserStatsResponse({
    required this.ratingDistribution,
    required this.ratingSummary,
    required this.readingTime,
    required this.topLevelGenres,
    required this.subGenres,
  });

  factory UserStatsResponse.fromJson(Map<String, dynamic> json) {
    return UserStatsResponse(
      ratingDistribution: (json['rating_distribution'] as List? ?? [])
          .map((e) => RatingDist.fromJson(e)).toList(),
      ratingSummary: RatingSummary.fromJson(json['rating_summary'] ?? {}),
      readingTime: ReadingTime.fromJson(json['reading_time'] ?? {}),
      topLevelGenres: (json['top_level_genres'] as List? ?? [])
          .map((e) => GenreStat.fromJson(e)).toList(),
      subGenres: (json['sub_genres'] as List? ?? [])
          .map((e) => GenreStat.fromJson(e)).toList(),
    );
  }
}

// ... (RatingDist 등 다른 클래스는 기존 유지) ...
class RatingDist {
  final int rating;
  final int count;
  RatingDist({required this.rating, required this.count});

  factory RatingDist.fromJson(Map<String, dynamic> json) {
    return RatingDist(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class RatingSummary {
  final double average5;
  final int totalReviews;
  final double mostFrequentRating;
  final int average100;
  final int totalComments; // ✅ [추가] 코멘트 개수 필드

  RatingSummary({
    required this.average5,
    required this.totalReviews,
    required this.mostFrequentRating,
    required this.average100,
    required this.totalComments, // ✅ [추가] 생성자
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      average5: (json['average_5'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      mostFrequentRating: (json['most_frequent_rating'] as num?)?.toDouble() ?? 0.0,
      average100: (json['average_100'] as num?)?.toInt() ?? 0,
      // ✅ [핵심] JSON의 'total_comments'를 가져옵니다.
      totalComments: (json['total_comments'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReadingTime {
  final int totalSeconds;
  final String human;

  ReadingTime({required this.totalSeconds, required this.human});

  factory ReadingTime.fromJson(Map<String, dynamic> json) {
    return ReadingTime(
      totalSeconds: (json['total_seconds'] as num?)?.toInt() ?? 0,
      human: json['human'] ?? "0시간",
    );
  }
}

class GenreStat {
  final String name;
  final int reviewCount;
  final double average5;

  GenreStat({
    required this.name,
    required this.reviewCount,
    required this.average5,
  });

  factory GenreStat.fromJson(Map<String, dynamic> json) {
    return GenreStat(
      name: json['name'] ?? '',
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      average5: (json['average_5'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class UserInsightResponse {
  final String analysis;
  final List<InsightTag> tags;

  UserInsightResponse({required this.analysis, required this.tags});

  factory UserInsightResponse.fromJson(Map<String, dynamic> json) {
    return UserInsightResponse(
      analysis: json['analysis'] ?? '',
      tags: (json['tags'] as List? ?? [])
          .map((e) => InsightTag.fromJson(e))
          .toList(),
    );
  }
}

class InsightTag {
  final String label;
  final double weight;

  InsightTag({required this.label, required this.weight});

  factory InsightTag.fromJson(Map<String, dynamic> json) {
    return InsightTag(
      label: json['label'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}