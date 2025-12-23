class ReadingBookSummary {
  final int bookId;
  final int totalSessionSeconds;
  final int progressPercent;
  final int sessionsCount;
  final String? lastReadAt;
  final int maxEndPage; // 이게 현재 페이지(currentPage)가 됩니다.
  final int startPage;
  final int totalPages;

  ReadingBookSummary({
    required this.bookId,
    required this.totalSessionSeconds,
    required this.progressPercent,
    required this.sessionsCount,
    this.lastReadAt,
    required this.maxEndPage,
    required this.startPage,
    required this.totalPages,
  });

  factory ReadingBookSummary.fromJson(Map<String, dynamic> json) {
    return ReadingBookSummary(
      bookId: json['book_id'] ?? 0,
      totalSessionSeconds: (json['total_session_seconds'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toInt() ?? 0,
      sessionsCount: (json['sessions_count'] as num?)?.toInt() ?? 0,
      lastReadAt: json['last_read_at'],
      maxEndPage: (json['max_end_page'] as num?)?.toInt() ?? 0,
      startPage: (json['start_page'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
    );
  }
}