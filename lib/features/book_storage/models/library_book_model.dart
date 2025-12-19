class LibraryBookModel {
  final int id;
  final String title;
  final String thumbnail;
  final double? myRating;
  final double? avgRating;
  final String status;
  final DateTime? addedAt;
  final DateTime? completedAt;

  LibraryBookModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    this.myRating,
    this.avgRating,
    required this.status,
    this.addedAt,
    this.completedAt,
  });

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) {
    // API 명세서: 항목 정보는 'book' 키 안에 들어있음
    final bookData = json['book'] is Map ? json['book'] : {};

    // 날짜 안전 파싱 함수
    DateTime? safeParse(dynamic value) {
      if (value == null || value.toString().isEmpty) return null;
      return DateTime.tryParse(value.toString());
    }

    return LibraryBookModel(
      id: (bookData['id'] ?? 0) as int,
      title: (bookData['title'] ?? '제목 없음').toString(),
      thumbnail: (bookData['thumbnail'] ?? '').toString(),
      // 사용자 평점 및 평균 평점 (num 타입 대응)
      myRating: (json['my_rating'] as num?)?.toDouble(),
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      status: (json['status'] ?? 'reading').toString(),
      addedAt: safeParse(json['added_at']),
      completedAt: safeParse(json['completed_at']),
    );
  }
}