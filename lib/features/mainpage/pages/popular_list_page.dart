import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';
import 'book_detail_page.dart';

class PopularListPage extends StatelessWidget {
  const PopularListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 이미 메모리에 있는 MainpageController를 찾아서 사용
    final controller = Get.find<MainpageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('인기 순위', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // 로딩 중일 때
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 데이터가 없을 때
        if (controller.popularBookList.isEmpty) {
          return const Center(child: Text("데이터가 없습니다."));
        }

        // 데이터 리스트 표시 (API에서 가져온 20~30개 전체)
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.popularBookList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final book = controller.popularBookList[index];

            return GestureDetector(
              onTap: () {
                // 상세 페이지로 이동하며 데이터 전달
                Get.to(() => BookDetailPage(
                  bookTitle: book['title'],
                  author: book['author'],
                  imageUrl: book['imageUrl'],
                  rating: book['rating'],
                ));
              },
              // 기존 Row 코드는 그대로 child로 들어감
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 책 표지
                  Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                      image: DecorationImage(
                        image: NetworkImage(book['imageUrl']),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // 순위 및 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${book['rank']}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                            '${book['author']} | 평균 ★ ${book['rating']}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}