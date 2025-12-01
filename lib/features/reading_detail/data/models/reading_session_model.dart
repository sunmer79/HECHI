class ReadingSessionModel {
  final int id;
  final int bookId;
  final int startPage;
  final int endPage;
  final int totalSeconds;
  final String startTime;
  final String endTime;

  ReadingSessionModel({
    required this.id,
    required this.bookId,
    required this.startPage,
    required this.endPage,
    required this.totalSeconds,
    required this.startTime,
    required this.endTime,
  });

  factory ReadingSessionModel.fromJson(Map<String, dynamic> json) {
    return ReadingSessionModel(
      id: json['id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      startPage: json['start_page'] ?? 0,
      endPage: json['end_page'] ?? 0,
      totalSeconds: json['total_seconds'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}