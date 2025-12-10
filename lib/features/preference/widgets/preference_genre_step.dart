import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';
import 'preference_top_bar.dart';
import 'preference_title.dart';
import 'genre_chip_item.dart';

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

            const PreferenceTitle(highlight: '장르', subText: "선호하는 장르를 선택해주세요."),
            const SizedBox(height: 40),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: controller.genres.map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GenreChipItem(item: g, controller: controller),
                      )).toList(),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}