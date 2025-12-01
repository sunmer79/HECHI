import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../data/search_repository.dart';

class SearchHistoryListWidget extends GetView<BookSearchController> {
  const SearchHistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      color: Colors.white,
      child: Column(
        children: [
          // 헤더
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
          // 리스트
          Expanded(
            child: Obx(() {
              if (controller.recentSearches.isEmpty) return const SizedBox();
              return ListView.builder(
                padding: EdgeInsets.zero,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final SearchHistoryItem item = controller.recentSearches[index];
                  return _buildHistoryItem(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // 검색어 클릭 시 검색 실행
          controller.searchTextController.text = item.query;
          controller.onSubmit(item.query);
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
                      child: Text(
                        item.query, // 검색어 텍스트
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF3F3F3F), fontSize: 16, fontFamily: 'Roboto'),
                      ),
                    ),
                  ],
                ),
              ),

              // 개별 삭제 버튼
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // [핵심] 삭제 함수에 'ID'를 넘겨줍니다.
                    controller.deleteOneHistory(item.id);
                  },
                  child: Container(
                    width: 30, height: 30, alignment: Alignment.center,
                    child: const Icon(Icons.close, size: 18, color: Color(0xFF3F3F3F)),
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