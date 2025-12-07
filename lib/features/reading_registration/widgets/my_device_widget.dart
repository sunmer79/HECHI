import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_registration_controller.dart';

class MyDeviceWidget extends GetView<ReadingRegistrationController> {
  const MyDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. 연결된 기기가 아예 없을 때 (삭제됨)
      if (!controller.hasDevice.value) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            // 배경색 없음 (투명)
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.bluetooth_disabled, size: 40, color: Color(0xFFCCCCCC)),
              SizedBox(height: 12),
              Text(
                "연결된 기기가 없습니다.\n블루투스를 켜 기기를 연결해주세요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
              ),
            ],
          ),
        );
      }

      // 2. 기기가 등록되어 있을 때
      final isConnected = controller.isStopperConnected.value;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        // 배경색 제거 요청 반영 (기본 투명)
        child: Row(
          children: [
            // 블루투스 아이콘 (클릭 시 연결 토글)
            GestureDetector(
              onTap: controller.toggleConnection,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Icon(
                  isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                  color: isConnected ? Colors.blueAccent : const Color(0xFF8E8E93),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.displayDeviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // 상태 표시 원
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isConnected ? const Color(0xFF4CAF50) : const Color(0xFFF44336), // 초록/빨강
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isConnected
                            ? "연결됨 • 배터리 ${controller.batteryLevel.value}%"
                            : "연결 끊김",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 상세 페이지 이동 아이콘 (i)
            IconButton(
              onPressed: controller.navigateToStopperDetail,
              icon: const Icon(Icons.info_outline, color: Color(0xFF8E8E93)),
            ),
          ],
        ),
      );
    });
  }
}