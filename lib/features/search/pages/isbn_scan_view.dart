import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/isbn_scan_controller.dart';

class IsbnScanView extends StatelessWidget {
  const IsbnScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final IsbnScanController controller = Get.put(IsbnScanController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.no_photography, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                const Text("윈도우 테스트 모드\n(카메라 비활성화됨)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => controller.testScan("9791190090018"),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("테스트용 ISBN 스캔하기"),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('HECHI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 28), onPressed: () => Get.back()),
                ],
              ),
            ),
          ),
          Obx(() => controller.isScanning.value ? const Center(child: CircularProgressIndicator()) : const SizedBox()),
        ],
      ),
    );
  }
}