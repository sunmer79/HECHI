import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/search_repository.dart';
import '../pages/book_detail_view.dart';

class IsbnScanController extends GetxController {
  final SearchRepository _repository = SearchRepository();
  final RxBool isScanning = false.obs;

  Future<void> testScan(String virtualCode) async {
    if (isScanning.value) return;

    isScanning.value = true;
    print("⚡ [테스트 스캔] 가짜 바코드 입력됨: $virtualCode");

    try {
      final book = await _repository.searchByBarcode(virtualCode);
      if (book != null) {
        Get.off(() => BookDetailView(book: book));
      } else {
        Get.snackbar("알림", "책 정보를 찾을 수 없습니다.");
        isScanning.value = false;
      }
    } catch (e) {
      print("API 에러: $e");
      isScanning.value = false;
    }
  }
}