import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/app_controller.dart';
import '../../app/routes.dart';

class BottomBar extends GetView<AppController> {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildNavItem(0, 25.94, '홈', 'assets/icons/icon_home.png', 29.93, 60.0),
            _buildNavItem(1, 108.74, '검색', 'assets/icons/icon_search.png', 29.93, 60.0),
            _buildNavItem(2, 191.54, '독서 등록', 'assets/icons/icon_register.png', 29.93, 82.0),
            _buildNavItem(3, 274.33, '리워드', 'assets/icons/icon_reward.png', 29.93, 56.0),
            _buildNavItem(4, 357.13, '나의 독서', 'assets/icons/icon_user.png', 29.93, 62.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, double left, String label, String iconPath, double width, double textWidth) {
    return Positioned(
      left: left,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          controller.changeIndex(index);

          if (Get.currentRoute != Routes.initial) {
            Get.offAllNamed(Routes.initial);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final bool isSelected = controller.currentIndex.value == index;
                final Color color = isSelected ? const Color(0xFF3F3F3F) : const Color(0xFFABABAB);

                return Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),
              SizedBox(
                width: width, height: 14,
                child: OverflowBox(
                  maxWidth: textWidth, minWidth: textWidth,
                  child: Center(
                    child: Obx(() {
                      final bool isSelected = controller.currentIndex.value == index;
                      return Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 11, fontFamily: 'Inter', height: 1.0,
                          color: isSelected ? const Color(0xFF3F3F3F) : const Color(0xFFABABAB),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}