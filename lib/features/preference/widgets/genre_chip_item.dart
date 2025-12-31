import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';

class GenreChipItem extends StatelessWidget {
  final String item;
  final PreferenceController controller;

  const GenreChipItem({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedGenres.contains(item);
      return GestureDetector(
        onTap: () => controller.toggleGenre(item),
        child: Container(
          constraints: const BoxConstraints(minWidth: 120),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(30),
            border: isSelected ? Border.all(color: const Color(0xFF4DB56C), width: 1.5) : null,
          ),
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xFF4DB56C) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}