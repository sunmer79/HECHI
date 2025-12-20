class FaqModel {
  final int id;
  final String question;
  final String answer;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class TicketModel {
  final int id;
  final String title;
  final String description;
  final String? fileUrl;
  final String status;
  final String createdAt;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    this.fileUrl,
    required this.status,
    required this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? 0,
      title: json['inquiryTitle'] ?? json['title'] ?? '',
      description: json['inquiryDescription'] ?? json['description'] ?? '',
      fileUrl: json['inquiryFileUrl'],
      status: json['status'] ?? 'open',
      createdAt: json['created_at'] ?? '',
    );
  }

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final date = DateTime.parse(createdAt);
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt;
    }
  }

  String get displayStatus {
    switch (status) {
      case 'answered':
        return '답변 완료';
      case 'open':
        return '접수 완료';
      default:
        return '처리 중';
    }
  }
}