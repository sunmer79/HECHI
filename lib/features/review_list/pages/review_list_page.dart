import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_list_controller.dart';
import '../widgets/review_card.dart';
import '../widgets/sort_bottom_sheet.dart';

class ReviewListPage extends GetView<ReviewListController> {
  const ReviewListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '코멘트',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // 📌 정렬 바
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                const SortBottomSheet(),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              color: const Color(0xFFF3F3F3),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                children: [
                  Obx(() => Text(
                    controller.sortText,
                    style: const TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 15,
                    ),
                  )),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF3F3F3F)),
                ],
              ),
            ),
          ),

          // 📌 리뷰 리스트
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.reviews.isEmpty) {
                return const Center(child: Text("리뷰가 없습니다."));
              }
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: controller.reviews.length,
                separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                itemBuilder: (context, index) {
                  return ReviewCard(
                    review: controller.reviews[index],
                    isMyReview: controller.reviews[index]['is_my_review'] ?? false,

                    onEdit: (id) => controller.editReview(id),
                    onDelete: (id) => controller.deleteReview(id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}