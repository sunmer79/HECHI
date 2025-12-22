import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';

class BookCoverHeader extends GetView<ReadingDetailController> {
  const BookCoverHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ====== 이미지 영역 ======
        Obx(() {
          final coverUrl = controller.coverImageUrl.value;
          return Container(
            width: double.infinity,
            height: 200,
            color: const Color(0xFFF0F0F0),
            child: coverUrl.isNotEmpty
                ? Image.network(
              coverUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey)),
            )
                : Image.asset(
              "assets/icons/ex_bookdetailcover.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          );
        }),

        // ====== 상단 어두운 그라데이션 (뒤로가기 아이콘 시인성) ======
        Container(
          height: 120,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
          ),
        ),

        // ====== 하단 흰색 그라데이션 (본문과 이어지는 부분) ======
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}