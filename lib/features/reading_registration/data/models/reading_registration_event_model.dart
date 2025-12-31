class ReadingRegistrationEvent {
  final int? id;
  final String eventType;
  final int page;
  final String occurredAt;

  ReadingRegistrationEvent({
    this.id,
    required this.eventType,
    required this.page,
    required this.occurredAt,
  });

  factory ReadingRegistrationEvent.fromJson(Map<String, dynamic> json) {
    return ReadingRegistrationEvent(
      id: json['id'],
      eventType: json['event_type'] ?? '',
      page: json['page'] ?? 0,
      occurredAt: json['occurred_at'] ?? '',
    );
  }
}