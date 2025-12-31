class LibraryBookModel {
  final int id;
  final String title;
  final String thumbnail;
  final double? myRating;
  final double? avgRating;
  final String status;

  LibraryBookModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    this.myRating,
    this.avgRating,
    required this.status,
  });

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) {
    final bookData = json['book'] is Map ? json['book'] : {};
    return LibraryBookModel(
      id: (bookData['id'] ?? 0) as int,
      title: (bookData['title'] ?? '제목 없음').toString(),
      thumbnail: (bookData['thumbnail'] ?? '').toString(),
      myRating: json['my_rating'] != null ? (json['my_rating'] as num).toDouble() : null,
      avgRating: json['avg_rating'] != null ? (json['avg_rating'] as num).toDouble() : null,
      status: (json['status'] ?? '').toString(),
    );
  }
}