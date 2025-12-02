class UserStatsResponse {
  final List<RatingDist> ratingDistribution;
  final RatingSummary ratingSummary;
  final ReadingTime readingTime;
  final List<GenreStat> topLevelGenres;
  final List<GenreStat> subGenres; // ✅ Dart에서는 변수명을 subGenres로 정의함

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
      // ✅ JSON의 'sub_genres'를 Dart의 'subGenres'로 매핑
      subGenres: (json['sub_genres'] as List? ?? [])
          .map((e) => GenreStat.fromJson(e)).toList(),
    );
  }
}

// ... (나머지 클래스들 RatingDist, GenreStat 등은 기존과 동일)
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

  RatingSummary({
    required this.average5,
    required this.totalReviews,
    required this.mostFrequentRating,
    required this.average100,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      average5: (json['average_5'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      mostFrequentRating: (json['most_frequent_rating'] as num?)?.toDouble() ?? 0.0,
      average100: (json['average_100'] as num?)?.toInt() ?? 0,
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