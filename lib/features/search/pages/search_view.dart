import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_header_widget.dart';
import '../widgets/search_history_list_widget.dart';
import '../widgets/search_result_widget.dart';

class SearchView extends GetView<BookSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 412),
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60.0,
                  child: Container(
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  top: 14.0,
                  left: 0,
                  right: 0,
                  child: const SearchHeaderWidget(),
                ),

                Positioned(
                  top: 93.0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Obx(() => _buildBody()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.currentView.value) {
      case SearchState.initial:
        return const Center(child: Text('검색어를 입력하세요', style: TextStyle(color: Colors.grey)));
      case SearchState.emptyHistory:
        return const Center(child: Text('최근 검색 기록이 없습니다.', style: TextStyle(color: Colors.grey)));
      case SearchState.hasHistory:
        return const SearchHistoryListWidget();
      case SearchState.result:
        return const SearchResultWidget();
    }
  }
}