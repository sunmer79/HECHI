import 'package:flutter/material.dart';

class InquiryTile extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final VoidCallback onTap;

  const InquiryTile({
    Key? key,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(date),
      trailing: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: status == '답변 완료' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}