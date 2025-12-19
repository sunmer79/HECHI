import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/bottom_bar.dart';
import '../controllers/book_storage_controller.dart';
import '../models/library_book_model.dart';

class BookStorageView extends GetView<BookStorageController> {
  const BookStorageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildFilterSection(),
            _buildBookList(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Stack(
        children: [
          const Center(child: Text('도서 보관함', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
          Positioned(left: 0, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back())),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final labels = ['읽는 중', '완독한', '평가한', '위시리스트'];
    return Container(
      height: 50,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDADADA), width: 1))),
      child: Obx(() => Row(
        children: List.generate(4, (index) {
          bool isSelected = controller.currentTabIndex.value == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(border: isSelected ? const Border(bottom: BorderSide(color: Colors.black, width: 2)) : null),
                child: Text(labels[index], style: TextStyle(
                  color: isSelected ? Colors.black : const Color(0xFF888888),
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )),
              ),
            ),
          );
        }),
      )),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 50,
      color: const Color(0xFFF3F3F3),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Spacer(),
          Obx(() => Text('${controller.books.length} 개', style: const TextStyle(fontSize: 14, color: Color(0xFF555555)))),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: controller.showSortBottomSheet,
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18, color: Color(0xFF555555)),
                const SizedBox(width: 4),
                Obx(() => Text(controller.currentSort.value, style: const TextStyle(fontSize: 14, color: Color(0xFF555555)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        if (controller.books.isEmpty) return const Center(child: Text('보관된 도서가 없습니다.'));
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.52,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: controller.books.length,
          itemBuilder: (context, index) => _BookGridItem(book: controller.books[index]),
        );
      }),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  final LibraryBookModel book;
  const _BookGridItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<BookStorageController>().goToBookDetails(book.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
                image: book.thumbnail.isNotEmpty ? DecorationImage(image: NetworkImage(book.thumbnail), fit: BoxFit.cover) : null,
              ),
              child: book.thumbnail.isEmpty ? const Icon(Icons.book, color: Colors.grey) : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(height: 4),
          _buildRatingInfo(),
        ],
      ),
    );
  }

  Widget _buildRatingInfo() {
    final bool hasMyRating = book.myRating != null && book.myRating! > 0;
    final double rating = hasMyRating ? book.myRating! : (book.avgRating ?? 0.0);
    final Color ratingColor = hasMyRating ? const Color(0xFFFF7F00) : const Color(0xFFAAAAAA);

    if (rating == 0 && !hasMyRating) {
      return const Text('평가 없음', style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 11));
    }

    return Row(
      children: [
        Icon(Icons.star, size: 12, color: ratingColor),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(color: ratingColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}