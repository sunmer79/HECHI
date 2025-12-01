class Book {
  final int id;
  final String title;
  final String? isbn;
  final String? publisher;
  final String? publishedDate;
  final String? thumbnail;
  final List<String>? authors;
  final String? category;

  Book({
    required this.id,
    required this.title,
    this.isbn,
    this.publisher,
    this.publishedDate,
    this.thumbnail,
    this.authors,
    this.category,
  });

  String get authorString {
    if (authors == null || authors!.isEmpty) return '작자 미상';
    return authors!.join(', ');
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '제목 없음',
      isbn: json['isbn'],
      publisher: json['publisher'] ?? '출판사 정보 없음',
      publishedDate: json['published_date'],
      thumbnail: (json['thumbnail'] != null && json['thumbnail'].toString().startsWith('http'))
          ? json['thumbnail']
          : null,
      authors: json['authors'] != null
          ? List<String>.from(json['authors'])
          : [],
      category: json['category'],
    );
  }
}