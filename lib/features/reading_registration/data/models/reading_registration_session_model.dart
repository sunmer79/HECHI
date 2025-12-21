import 'reading_registration_event_model.dart';

class ReadingRegistrationSession {
  final int id;
  final int userId;
  final int bookId;
  final String startTime;
  final String? endTime;
  final int startPage;
  final int endPage;
  final int totalSeconds;
  final List<ReadingRegistrationEvent> events;

  ReadingRegistrationSession({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.startTime,
    this.endTime,
    required this.startPage,
    required this.endPage,
    required this.totalSeconds,
    required this.events,
  });

  factory ReadingRegistrationSession.fromJson(Map<String, dynamic> json) {
    return ReadingRegistrationSession(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'],
      startPage: json['start_page'] ?? 0,
      endPage: json['end_page'] ?? 0,
      totalSeconds: json['total_seconds'] ?? 0,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => ReadingRegistrationEvent.fromJson(e))
          .toList() ??
          [],
    );
  }
}