import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../pages/book_detail_view.dart';

class SearchResultWidget extends GetView<BookSearchController> {
  const SearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.backToSearch,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => Text(
                  '"${controller.currentKeyword.value}" 검색 결과',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
              if (controller.searchResults.isEmpty) return const Center(child: Text('검색된 도서가 없습니다.'));

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: controller.searchResults.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final book = controller.searchResults[index];
                  return InkWell(
                    onTap: () => Get.to(() => BookDetailView(book: book)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60, height: 86,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: (book.thumbnail != null)
                                ? Image.network(book.thumbnail!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                                : const Icon(Icons.book, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(book.authorString, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
                                const SizedBox(height: 4),
                                Text(book.publisher ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}