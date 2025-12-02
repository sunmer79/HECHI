class MyReadStats {
  final List<RatingDist> ratingDistribution;
  final RatingSummary ratingSummary;
  final ReadingTime readingTime;
  final List<GenreStat> topLevelGenres;

  // API 명세서에 sub_genres 필드가 있었으므로 포함합니다.
  final List<GenreStat> subGenres;

  MyReadStats({
    required this.ratingDistribution,
    required this.ratingSummary,
    required this.readingTime,
    required this.topLevelGenres,
    required this.subGenres,
  });

  // API의 JSON 형태를 Dart 클래스로 변환하는 로직입니다.
  factory MyReadStats.fromJson(Map<String, dynamic> json) {
    return MyReadStats(
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

class RatingDist {
  final int rating;
  final int count;
  RatingDist({required this.rating, required this.count});

  factory RatingDist.fromJson(Map<String, dynamic> json) {
    return RatingDist(rating: json['rating'] ?? 0, count: json['count'] ?? 0);
  }
}

class RatingSummary {
  final double average;
  final int totalReviews;
  final double mostFrequent;

  RatingSummary({required this.average, required this.totalReviews, required this.mostFrequent});

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      // average_5를 double로 변환
      average: (json['average_5'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      mostFrequent: (json['most_frequent_rating'] ?? 0).toDouble(),
    );
  }
}

class ReadingTime {
  final String human;
  ReadingTime({required this.human});

  factory ReadingTime.fromJson(Map<String, dynamic> json) {
    return ReadingTime(human: json['human'] ?? "0시간");
  }
}

class GenreStat {
  final String name;
  final int count;
  final double average;

  GenreStat({required this.name, required this.count, required this.average});

  factory GenreStat.fromJson(Map<String, dynamic> json) {
    return GenreStat(
      name: json['name'] ?? '',
      count: json['review_count'] ?? 0,
      // average_5를 double로 변환
      average: (json['average_5'] ?? 0).toDouble(),
    );
  }
}