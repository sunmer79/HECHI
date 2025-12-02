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
    final bookData = json['book'] ?? {};

    final idValue = bookData['id'] ?? bookData['book_id'];

    return LibraryBookModel(
      // idValue가 num 타입일 경우 정수로 변환하고, 그 외의 경우 (null 포함) 0을 할당합니다.
      id: (idValue is num) ? idValue.toInt() : 0,

      title: bookData['title'] ?? '',
      thumbnail: bookData['thumbnail'] ?? '',
      myRating: (json['my_rating'] as num?)?.toDouble(),
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      status: json['status'] ?? 'reading',
    );
  }
}