import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchHeaderWidget extends GetView<BookSearchController> {
  const SearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isResultMode = controller.currentView.value == SearchState.result;

      return Container(
        width: 412,
        height: 62,
        padding: EdgeInsets.only(left: 16, right: 16, top: 20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
          height: 30,
          decoration: ShapeDecoration(
            color: const Color(0xFFF4F4F4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          child: TextField(
            controller: controller.searchTextController,
            focusNode: controller.searchFocusNode,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color(0xFF3F3F3F)),
              suffixIcon: Obx(() {
                if (controller.isTextEmpty.value) {
                  return IconButton(
                    icon: const Icon(
                      CupertinoIcons.barcode_viewfinder,
                      color: Color(0xFF3F3F3F),
                      size: 24,
                    ),
                    onPressed: controller.navigateToIsbnScan,
                  );
                } else {
                  return IconButton(
                      onPressed: controller.clearSearchText,
                      icon: Container(
                          width: 20, height: 20,
                          decoration: const BoxDecoration(color: Color(0xFF8E8E93), shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 14, color: Colors.white)
                      )
                  );
                }
              }),
              hintText: '검색',
              hintStyle: const TextStyle(color: Color(0xFF3F3F3F), fontSize: 16, fontFamily: 'Roboto'),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: controller.onSubmit,
          ),
        ),
      );
    });
  }
}