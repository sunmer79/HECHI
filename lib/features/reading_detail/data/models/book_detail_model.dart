class BookDetailModel {
  final int id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String category;
  final int totalPages;
  final String? thumbnail;

  BookDetailModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.category,
    required this.totalPages,
    this.thumbnail,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) {
    return BookDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      authors: json['authors'] != null
          ? List<String>.from(json['authors'].map((x) => x.toString()))
          : [],
      publisher: json['publisher'] ?? '',
      publishedDate: json['published_date'] ?? '',
      category: json['category'] ?? '',
      totalPages: json['total_pages'] ?? 0,
      thumbnail: json['thumbnail'],
    );
  }
}