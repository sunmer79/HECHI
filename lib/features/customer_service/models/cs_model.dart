class FaqModel {
  final int id;
  final String question;
  final String answer;
  final bool isPinned;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.isPinned,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      isPinned: json['is_pinned'] ?? false,
    );
  }
}

class TicketModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final String createdAt;

  TicketModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '접수완료',
      createdAt: json['created_at'] ?? '',
    );
  }

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final date = DateTime.parse(createdAt);
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return createdAt.substring(0, 10);
    }
  }
}