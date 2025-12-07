import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';

class StopperDetailView extends GetView<ReadingRegistrationController> {
  const StopperDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "북스토퍼 설정",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기기 이름 표시/설정 영역
            Center(
              child: Column(
                children: [
                  const Icon(Icons.bluetooth_connected, size: 60, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    controller.displayDeviceName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 정보 섹션
            const Text("기기 정보", style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow("모델명", controller.modelName),
                  const Divider(),
                  _buildInfoRow("모델 번호", "H-SP-25-KR"),
                  const Divider(),
                  _buildInfoRow("일련 번호", "SN-20251207-001"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 버튼들
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: controller.disconnectDeviceAction,
                child: const Text("연결 해제 (Disconnect)"),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: controller.forgetDeviceAction,
                child: const Text("이 기기 지우기 (Forget)"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF333333))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}