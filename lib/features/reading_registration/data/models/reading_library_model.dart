class ReadingBook {
  final int id;
  final String title;
  final String thumbnail;
  final List<String> authors;
  final int totalPages;

  ReadingBook({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.authors,
    required this.totalPages,
  });

  factory ReadingBook.fromJson(Map<String, dynamic> json) {
    return ReadingBook(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      authors: (json['authors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
    );
  }
}

class ReadingLibraryItem {
  final ReadingBook book;
  final String status;
  final int currentPage;
  final int progressPercent;
  final double? myRating;
  final int totalSessionSeconds; // [추가] 총 읽은 시간

  ReadingLibraryItem({
    required this.book,
    required this.status,
    required this.currentPage,
    required this.progressPercent,
    this.myRating,
    this.totalSessionSeconds = 0, // [추가] 기본값 0
  });

  factory ReadingLibraryItem.fromJson(Map<String, dynamic> json) {
    return ReadingLibraryItem(
      book: ReadingBook.fromJson(json['book'] ?? {}),
      status: json['status'] ?? '',
      currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
      progressPercent: json['progress_percent'] ?? 0,
      myRating: (json['my_rating'] as num?)?.toDouble(),
      totalSessionSeconds: (json['total_session_seconds'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReadingLibraryResponse {
  final int total;
  final List<ReadingLibraryItem> items;

  ReadingLibraryResponse({
    required this.total,
    required this.items,
  });

  factory ReadingLibraryResponse.fromJson(Map<String, dynamic> json) {
    return ReadingLibraryResponse(
      total: json['total'] ?? 0,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ReadingLibraryItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}