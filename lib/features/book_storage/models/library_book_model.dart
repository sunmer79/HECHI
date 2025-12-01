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
    return LibraryBookModel(
      id: bookData['id'] ?? 0,
      title: bookData['title'] ?? '',
      thumbnail: bookData['thumbnail'] ?? '',
      myRating: (json['my_rating'] as num?)?.toDouble(),
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      status: json['status'] ?? 'reading',
    );
  }
}