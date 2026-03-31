import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';
import 'preference_title.dart';
import 'preference_top_bar.dart';

class PreferenceCategoryStep extends StatelessWidget {
  final PreferenceController controller;

  const PreferenceCategoryStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            PreferenceTopBar(text: '다음', onTap: controller.nextStep),
            const SizedBox(height: 40),

            const PreferenceTitle(
                highlight: '카테고리',
                subText: '평소 읽는 도서의 종류를 골라주세요.'
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Obx(() => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final item = controller.categories[index];
                  final isSelected = controller.selectedCategories.contains(item);
                  return _buildCategoryItem(item, isSelected);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String item, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleCategory(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4DB56C) : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
            item,
            style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF3F3F3F),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
            ),
            textAlign: TextAlign.center
        ),
      ),
    );
  }
}