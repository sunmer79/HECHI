import 'package:flutter/material.dart';
import '../controllers/preference_controller.dart';
import 'preference_top_bar.dart';
import 'preference_title.dart';
import 'category_circle_item.dart';

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

            const PreferenceTitle(highlight: '카테고리', subText: "하나 이상 선택해주세요."),
            const SizedBox(height: 40),

            Expanded(
              child: GridView.builder(
                itemCount: controller.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return CategoryCircleItem(
                    item: controller.categories[index],
                    controller: controller,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}