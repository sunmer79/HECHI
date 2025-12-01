import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchHistoryListWidget extends GetView<BookSearchController> {
  const SearchHistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: 412,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('최근 검색어', style: TextStyle(color: Color(0xFF3F3F3F), fontSize: 13)),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.clearAllHistory(),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('전체 삭제', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF3F3F3F), fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.recentSearches.isEmpty) return const SizedBox();
              return ListView.builder(
                padding: EdgeInsets.zero,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final title = controller.recentSearches[index];
                  return _buildHistoryItem(title, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          controller.searchTextController.text = title;
          controller.onSubmit(title);
        },
        child: Container(
          width: 412,
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: Color(0xFFB0B0B0)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF3F3F3F), fontSize: 16)),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => controller.deleteOneHistory(index),
                child: Container(
                  width: 30, height: 30, alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 18, color: Color(0xFF3F3F3F)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}