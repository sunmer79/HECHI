import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FaqTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF3F3F3F),
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFABABAB)),
    );
  }
}