import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/library_book_model.dart';
import '../data/book_storage_provider.dart';

class BookStorageController extends GetxController {
  final BookStorageProvider provider;
  BookStorageController({required this.provider});

  final RxInt currentTabIndex = 0.obs;
  final RxString currentSort = '최신 순'.obs;
  final RxString currentSortKey = 'latest'.obs;

  final RxList<LibraryBookModel> books = <LibraryBookModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  // 탭 변경 시 로그 추가
  void changeTab(int index) {
    print("📍 [Tab Change] $currentTabIndex -> $index");
    currentTabIndex.value = index;
    fetchBooks();
  }

  // API 파라미터 매핑 확인용 로그
  String get _currentShelfParam {
    switch (currentTabIndex.value) {
      case 0: return 'reading';
      case 1: return 'completed';
      case 2: return 'rated';
      case 3: return 'wishlist';
      default: return 'reading';
    }
  }

  /// 도서 목록 조회 (상세 로깅 버전)
  void fetchBooks() async {
    isLoading.value = true;

    // 현재 요청을 보내는 상태 로깅
    final shelf = _currentShelfParam;
    final sort = currentSortKey.value;
    print("🔍 [Fetch Request] Shelf: $shelf, Sort: $sort");

    try {
      final result = await provider.getLibraryBooks(
        shelf: shelf,
        sort: sort,
      );

      if (result.isEmpty) {
        print("⚠️ [Fetch Result] 서버에서 빈 목록을 반환했거나 오류가 발생했습니다.");
      } else {
        print("✅ [Fetch Success] ${result.length}개의 도서를 불러왔습니다.");
      }

      books.assignAll(result);
    } catch (e, stackTrace) {
      // 에러 발생 시 아주 상세하게 출력
      print("❌ [Controller Error] fetchBooks 도중 예외 발생!");
      print("에러 내용: $e");
      print("스택 트레이스: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  void goToBookDetails(int bookId) {
    const String detailRoute = '/reading_detail';

    // ID가 0인 경우(파싱 실패 등)에 대한 경고 로그
    if (bookId == 0) {
      print("⚠️ [Navigation Warning] 도서 ID가 0입니다. API 데이터를 확인하세요.");
    }

    Get.toNamed(
      detailRoute,
      arguments: {'bookId': bookId},
    );
    print('🚀 [Navigation] 도서 ID $bookId -> $detailRoute 이동');
  }

  void showSortBottomSheet() {
    // BottomSheet 내부의 상태 변경을 반영하기 위해 Obx로 감싸기
    Get.bottomSheet(
      Obx(() => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('정렬', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text('취소', style: TextStyle(color: Color(0xFF4DB56C), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildSortOption('최신 순', 'latest'),
            _buildSortOption('내 별점 높은 순', 'myRating'),
            _buildSortOption('평균 별점 높은 순', 'avgRating'),
            _buildSortOption('가나다 순', 'title'),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }

  Widget _buildSortOption(String label, String key) {
    return InkWell(
      onTap: () {
        print("🔃 [Sort Change] $currentSortKey -> $key");
        currentSort.value = label;
        currentSortKey.value = key;
        Get.back();
        fetchBooks();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: currentSortKey.value == key ? Colors.black : Colors.black87,
                fontWeight: currentSortKey.value == key ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (currentSortKey.value == key)
              const Icon(Icons.check, color: Color(0xFF4DB56C), size: 20),
          ],
        ),
      ),
    );
  }
}