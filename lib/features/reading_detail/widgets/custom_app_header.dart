import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';

class CustomAppHeader extends GetView<ReadingDetailController> {
  const CustomAppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          ),
        ],
      ),
    );
  }
}