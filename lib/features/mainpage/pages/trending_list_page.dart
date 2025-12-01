import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainpage_controller.dart';
import 'book_detail_page.dart'; // 상세 페이지 이동을 위해 필요

class TrendingListPage extends StatelessWidget {
  const TrendingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainpageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 순위 도서', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.trendingBookList.isEmpty) {
          return const Center(child: Text("데이터가 없습니다."));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.trendingBookList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final book = controller.trendingBookList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => BookDetailPage(
                  bookTitle: book['title'],
                  author: book['author'],
                  imageUrl: book['imageUrl'],
                  rating: book['rating'],
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                      image: DecorationImage(
                        image: NetworkImage(book['imageUrl']),
                        fit: BoxFit.cover,
                        onError: (e, s) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
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