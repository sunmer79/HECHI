import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';

class CategoryCircleItem extends StatelessWidget {
  final String item;
  final PreferenceController controller;

  const CategoryCircleItem({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedCategories.contains(item);
      return GestureDetector(
        onTap: () => controller.toggleCategory(item),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: const Color(0xFF4DB56C), width: 2) : null,
              ),
              child: Icon(
                _getIconForCategory(item),
                size: 40,
                color: isSelected ? const Color(0xFF4DB56C) : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF4DB56C) : const Color(0xFF3F3F3F),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    });
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case '소설': return Icons.import_contacts;
      case '시': return Icons.edit_outlined;
      case '에세이': return Icons.article_outlined;
      case '만화': return Icons.emoji_emotions_outlined;
      default: return Icons.book;
    }
  }
}