import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/preference_controller.dart';

class PreferenceView extends GetView<PreferenceController> {
  const PreferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        switch (controller.currentStep.value) {
          case 0:
            return _buildIntroStep();
          case 1:
            return _buildCategoryStep();
          case 2:
            return _buildGenreStep();
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildIntroStep() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF4DB56C),
      child: const Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '독서 ', style: TextStyle(color: Color(0xFFD1ECD9), fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
              TextSpan(text: '취향', style: TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.w900)),
              TextSpan(text: '\n알아보기', style: TextStyle(color: Color(0xFFD1ECD9), fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // [Step 1] 카테고리
  Widget _buildCategoryStep() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildTopBar(text: '다음', onTap: controller.nextStep),
            const SizedBox(height: 40),

            // ✅ [수정] 문구 변경 (최대 개수 제한 언급 삭제)
            _buildTitle(highlight: '카테고리', subText: "하나 이상 선택해주세요."),

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
                  return _buildCircleItem(controller.categories[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Step 2] 장르 (세로 리스트)
  Widget _buildGenreStep() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildTopBar(text: '완료', onTap: controller.nextStep),
            const SizedBox(height: 40),
            _buildTitle(highlight: '장르', subText: "선호하는 장르를 선택해주세요."),
            const SizedBox(height: 40),

            // ✅ [핵심] 세로 리스트 구현 (Wrap -> Column)
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
                        padding: const EdgeInsets.only(bottom: 16), // 아이템 간 간격
                        child: _buildChipItem(g),
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

  Widget _buildTopBar({required String text, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF4DB56C),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle({required String highlight, required String subText}) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '내가 좋아하는 ', style: TextStyle(color: Colors.black, fontSize: 20)),
              TextSpan(text: highlight, style: const TextStyle(color: Color(0xFF4DB56C), fontSize: 24, fontWeight: FontWeight.bold)),
              const TextSpan(text: '는?', style: TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(subText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildCircleItem(String item) {
    return Obx(() {
      final isSelected = controller.selectedCategories.contains(item);
      return GestureDetector(
        onTap: () => controller.toggleCategory(item),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
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

  Widget _buildChipItem(String item) {
    final isSelected = controller.selectedGenres.contains(item);
    return GestureDetector(
      onTap: () => controller.toggleGenre(item),
      child: Container(
        // 세로 리스트에 어울리는 너비 조정
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