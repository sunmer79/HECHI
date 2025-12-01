import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 패키지 import 필수
import '../data/search_repository.dart';

class IsbnScanController extends GetxController {
  // 1. 실제 카메라 컨트롤러 생성
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // 중복 스캔 방지
    returnImage: false, // 모바일에서는 false가 성능상 유리
    autoStart: true,    // 페이지 들어오면 바로 시작
  );

  final SearchRepository _repository = SearchRepository();
  final RxBool isScanning = false.obs; // API 통신 중복 방지

  @override
  void onClose() {
    // 컨트롤러 해제 (에러 무시 처리 포함)
    try {
      cameraController.dispose();
    } catch (e) {
      print("카메라 종료 에러 무시: $e");
    }
    super.onClose();
  }

  // 2. 바코드 감지 시 실행되는 함수
  Future<void> onBarcodeDetect(BarcodeCapture capture) async {
    // 이미 스캔 중(로딩 중)이면 무시
    if (isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;

        // ISBN은 보통 10자리 or 13자리
        if (code.length == 10 || code.length == 13) {
          print("📸 스캔된 ISBN: $code");

          isScanning.value = true; // 로딩 시작

          try {
            // API 호출
            final book = await _repository.searchByBarcode(code);

            if (book != null) {
              Get.back(); // 스캔 화면 닫기
              Get.snackbar("스캔 성공", "'${book.title}'을(를) 찾았습니다. (상세 페이지 연결 예정)");
              print("📖 스캔된 책: ${book.title}");
            } else {
              // 실패 시 알림 띄우고 다시 스캔 가능하게
              Get.snackbar("알림", "책 정보를 찾을 수 없습니다.");
              await Future.delayed(const Duration(seconds: 2)); // 2초 뒤 재스캔 허용
              isScanning.value = false;
            }
          } catch (e) {
            print("API 에러: $e");
            Get.snackbar("오류", "서버 연결에 실패했습니다.");
            isScanning.value = false;
          }
          break; // 하나만 인식하고 루프 종료
        }
      }
    }
  }
}