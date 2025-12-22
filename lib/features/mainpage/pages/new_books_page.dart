import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/new_books_controller.dart'; // 컨트롤러 import 확인

// 💥 [수정됨] 클래스 이름을 BestsellerPage -> NewBooksPage로 변경
class NewBooksPage extends StatelessWidget {
  const NewBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 💥 [수정됨] 컨트롤러도 NewBooksController로 연결
    final controller = Get.put(NewBooksController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 💥 [수정됨] 타이틀 변경
        title: const Text('신간 도서', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.bookList.isEmpty) return const Center(child: Text("데이터가 없습니다."));

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.bookList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final book = controller.bookList[index];
            return GestureDetector(
              onTap: () => Get.toNamed('/book_detail_page', arguments: book['id']),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60, height: 90,
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
                          book['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${book['author']} | 평균 ★ ${book['rating']}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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