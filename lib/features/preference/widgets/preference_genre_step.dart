import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';
import 'preference_title.dart';
import 'preference_top_bar.dart';

class PreferenceGenreStep extends StatelessWidget {
  final PreferenceController controller;

  const PreferenceGenreStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            PreferenceTopBar(text: '완료', onTap: controller.nextStep),
            const SizedBox(height: 40),

            const PreferenceTitle(
                highlight: '장르',
                subText: '선호하는 세부 장르를 골라주세요.'
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Obx(() => GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16
                ),
                itemCount: controller.genres.length,
                itemBuilder: (context, index) {
                  final item = controller.genres[index];
                  final isSelected = controller.selectedGenres.contains(item);
                  return _buildGenreItem(item, isSelected);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreItem(String item, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleGenre(item),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4DB56C) : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
            item,
            style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF3F3F3F),
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
            )
        ),
      ),
    );
  }
}