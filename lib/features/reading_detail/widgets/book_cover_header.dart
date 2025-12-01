import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';

class BookCoverHeader extends GetView<ReadingDetailController> {
  const BookCoverHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              if (controller.coverImageUrl.value.isNotEmpty) {
                return Image.network(
                  controller.coverImageUrl.value,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/icons/ex_bookdetailcover.png",
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    );
                  },
                );
              } else {
                return Image.asset(
                  "assets/icons/ex_bookdetailcover.png",
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                );
              }
            }),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(1.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}