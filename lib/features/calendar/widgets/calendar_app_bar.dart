import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CalendarController controller;

  const CalendarAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, color: Colors.black54),
            onPressed: () => controller.changeMonth(-1),
          ),
          Obx(() => Text(
            "${controller.currentYear.value}년 ${controller.currentMonth.value}월",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          )),
          IconButton(
            icon: const Icon(Icons.arrow_right, color: Colors.black54),
            onPressed: () => controller.changeMonth(1),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}