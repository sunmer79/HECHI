import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 패키지 import
import '../controllers/isbn_scan_controller.dart';

class IsbnScanView extends StatelessWidget {
  const IsbnScanView({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 주입
    final IsbnScanController controller = Get.put(IsbnScanController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. 카메라 화면 (가장 뒤)
          MobileScanner(
            controller: controller.cameraController,
            onDetect: controller.onBarcodeDetect,
            // 에러 발생 시 화면 표시
            errorBuilder: (context, error, child) {
              return Center(
                child: Text(
                  '카메라 오류: ${error.errorCode}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),

          // 2. 회색 오버레이 + 투명 구멍 (디자인 복구)
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: ScannerOverlayPainter(),
          ),

          // 3. UI 요소들 (안내 텍스트, 닫기 버튼)
          SafeArea(
            child: Column(
              children: [
                // 상단 네비게이션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HECHI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // 안내 문구
                const Text(
                  '바코드를 영역에 맞춰 보세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '원하는 도서를 빠르게 찾을 수 있어요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // 노란색 가이드 라인 (실제 스캔 영역 표시)
                Container(
                  width: 300,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFE066), // 노란색
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),

          // 4. 로딩 인디케이터
          Obx(() {
            return controller.isScanning.value
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }),
        ],
      ),
    );
  }
}

// [복구] 회색 배경에 구멍 뚫는 페인터 클래스
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black.withOpacity(0.5);

    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 구멍 위치 및 크기 계산 (화면 중앙쯤)
    final double scanBoxWidth = 300;
    final double scanBoxHeight = 180;
    final double scanBoxTop = size.height * 0.35;
    final double scanBoxLeft = (size.width - scanBoxWidth) / 2;

    final Path cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(scanBoxLeft, scanBoxTop, scanBoxWidth, scanBoxHeight),
          const Radius.circular(8),
        ),
      );

    final Path path = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}