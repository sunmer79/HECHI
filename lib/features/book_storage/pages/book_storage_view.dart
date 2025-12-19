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
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          const Center(
            child: Text(
              '도서 보관함',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADADA), width: 1)),
      ),
      child: Obx(() => Row(
        children: [
          _buildTabItem(0, '읽는 중'),
          _buildTabItem(1, '완독한'),
          _buildTabItem(2, '평가한'),
          _buildTabItem(3, '위시리스트'),
        ],
      )),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool isSelected = controller.currentTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isSelected
                  ? const Border(bottom: BorderSide(color: Colors.black, width: 2))
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : const Color(0xFF888888),
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
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
          Obx(() => Text(
            '${controller.books.length} 개',
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
          )),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: controller.showSortBottomSheet,
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18, color: Color(0xFF555555)),
                const SizedBox(width: 4),
                Obx(() => Text(
                  controller.currentSort.value,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
                )),
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        }
        if (controller.books.isEmpty) {
          return const Center(child: Text('보관된 도서가 없습니다.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.52, // 시간 텍스트가 추가되어 높이를 소폭 늘림
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: controller.books.length,
          itemBuilder: (context, index) {
            return _BookGridItem(book: controller.books[index]);
          },
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
      onTap: () {
        Get.find<BookStorageController>().goToBookDetails(book.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
                image: book.thumbnail.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(book.thumbnail),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: book.thumbnail.isEmpty
                  ? const Icon(Icons.book, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 1, // 텍스트 겹침 방지를 위해 1줄로 제한 (원할 경우 2줄 유지 가능)
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          _buildInfoByStatus(), // 상태별 시간/별점 표시 위젯
        ],
      ),
    );
  }

  /// 상태(탭)에 따른 하단 정보 표시 로직
  Widget _buildInfoByStatus() {
    // 1. 완독한 상태일 때 (완독 날짜 표시)
    if (book.status == 'completed' && book.completedAt != null) {
      return Text(
        '${book.completedAt!.year}.${book.completedAt!.month.toString().padLeft(2, '0')}.${book.completedAt!.day.toString().padLeft(2, '0')} 완독',
        style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
      );
    }

    // 2. 평가한 상태일 때 (내 별점 표시)
    if (book.myRating != null && book.myRating! > 0) {
      return Text(
        '평가함 ★${book.myRating}',
        style: const TextStyle(
          color: Color(0xFFFF7F00),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 3. 위시리스트 상태일 때 (담은 날짜 표시)
    if (book.status == 'wishlist' && book.addedAt != null) {
      return Text(
        '${book.addedAt!.month}/${book.addedAt!.day} 담음',
        style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
      );
    }

    // 4. 기본/읽는 중 상태 (평균 별점 표시)
    return Text(
      '예상 ★${book.avgRating ?? 0.0}',
      style: const TextStyle(
        color: Color(0xFF4DB56C),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}