import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 10),
      child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F))
      ),
    );
  }
}