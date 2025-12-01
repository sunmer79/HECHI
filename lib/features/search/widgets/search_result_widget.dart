import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

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

                  // InkWell로 감싸서 책 전체 클릭 시 상세페이지 이동
                  return InkWell(
                    onTap: () {
                      print("📖 '${book.title}' 상세 페이지로 이동 (팀원 구현 예정)");
                      // 나중에 팀원이 만든 페이지로 연결: Get.toNamed('/book/detail', arguments: book);
                    },
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

                          // [수정] 체크 버튼 영역
                          // Obx로 감싸서 상태 변화(등록됨/안됨)를 즉시 반영
                          Obx(() {
                            final isRegistered = controller.registeredBookIds.contains(book.id);

                            return InkWell(
                              onTap: () {
                                if (!isRegistered) {
                                  // 등록 안 된 상태면 팝업 띄우기
                                  controller.showRegisterDialog(book);
                                } else {
                                  // 이미 등록된 상태라면? (지금은 그냥 안내 메시지)
                                  Get.snackbar("알림", "이미 등록된 도서입니다.", duration: const Duration(seconds: 1));
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  // 등록되었으면 채워진 원, 아니면 빈 원
                                  isRegistered ? Icons.check_circle : Icons.check_circle_outline,
                                  // 등록되었으면 진한 회색, 아니면 연한 회색
                                  color: isRegistered ? const Color(0xFF555555) : const Color(0xFF888888),
                                  size: 28,
                                ),
                              ),
                            );
                          }),
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