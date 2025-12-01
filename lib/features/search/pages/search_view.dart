import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_header_widget.dart';
import '../widgets/search_empty_widget.dart';
import '../widgets/search_history_list_widget.dart';
import '../widgets/search_result_widget.dart';

class SearchView extends GetView<BookSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(Get.currentRoute != '/search'){
        controller.searchFocusNode.unfocus();
      }
    });

    return Center(
      child: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => controller.searchFocusNode.unfocus(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            const Positioned(left: 0, top: 0, child: SearchHeaderWidget()),
            Positioned(
              left: 0, top: 90, bottom: 0,
              child: Obx(() {
                switch (controller.currentView.value) {
                  case SearchState.initial: return const SizedBox();
                  case SearchState.emptyHistory: return const Padding(padding: EdgeInsets.only(top: 20), child: SearchEmptyWidget());
                  case SearchState.hasHistory: return const Padding(padding: EdgeInsets.only(top: 20), child: SearchHistoryListWidget());
                  case SearchState.result: return const Padding(padding: EdgeInsets.only(top: 20), child: SearchResultWidget());
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}