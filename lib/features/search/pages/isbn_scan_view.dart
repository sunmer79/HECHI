import 'dart:io'; // [필수] 플랫폼 확인을 위해 추가
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/isbn_scan_controller.dart';

class IsbnScanView extends StatelessWidget {
  const IsbnScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final IsbnScanController controller = Get.put(IsbnScanController());

    // 윈도우(PC)일 경우 -> 전용 테스트 화면
    if (Platform.isWindows) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.no_photography, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "윈도우에서는 카메라를 사용할 수 없습니다.\n(테스트 모드)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => controller.testScan("9788936439743"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50), // 초록색 버튼
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("테스트용 ISBN 스캔하기", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      );
    }

    // 모바일(안드로이드/iOS)일 경우 -> 실제 카메라 화면
    final Size screenSize = MediaQuery.of(context).size;
    final double scanBoxWidth = 300;
    final double scanBoxHeight = 180;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. 카메라
          MobileScanner(
            controller: controller.cameraController,
            onDetect: controller.onBarcodeDetect,
            errorBuilder: (context, error, child) => const Center(child: Text('카메라 오류', style: TextStyle(color: Colors.white))),
          ),

          // 2. 오버레이 (배경 + 테두리)
          CustomPaint(
            size: screenSize,
            painter: ScannerOverlayPainter(
              scanBoxWidth: scanBoxWidth,
              scanBoxHeight: scanBoxHeight,
            ),
          ),

          // 3. UI 요소 (텍스트, 닫기 버튼)
          SafeArea(
            child: Column(
              children: [
                // 상단 닫기 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HECHI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                const Text('바코드를 영역에 맞춰 보세요', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('원하는 도서를 빠르게 찾을 수 있어요', style: TextStyle(color: Colors.white70, fontSize: 14)),

                const SizedBox(height: 60),

                SizedBox(width: scanBoxWidth, height: scanBoxHeight),

                const Spacer(flex: 1),
              ],
            ),
          ),

          // 4. 로딩
          Obx(() => controller.isScanning.value ? const Center(child: CircularProgressIndicator()) : const SizedBox()),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanBoxWidth;
  final double scanBoxHeight;

  ScannerOverlayPainter({required this.scanBoxWidth, required this.scanBoxHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    final Paint borderPaint = Paint()..color = const Color(0xFFFFE066)..style = PaintingStyle.stroke..strokeWidth = 4;

    final double left = (size.width - scanBoxWidth) / 2;
    final double top = (size.height - scanBoxHeight) / 2 - 40;
    final Rect scanRect = Rect.fromLTWH(left, top, scanBoxWidth, scanBoxHeight);
    final RRect scanRRect = RRect.fromRectAndRadius(scanRect, const Radius.circular(8));

    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(scanRRect);
    final Path finalPath = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);

    canvas.drawPath(finalPath, backgroundPaint);
    canvas.drawRRect(scanRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}