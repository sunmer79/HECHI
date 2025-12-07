import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_sheet.dart';

class HighlightItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  final VoidCallback? onCreateMemo;

  const HighlightItem({
    super.key,
    required this.data,
    required this.onDelete,
    this.onCreateMemo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 타임라인 (노란색)
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9C4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.push_pin_outlined, color: Color(0xFFFBC02D), size: 20),
            ),
            Container(width: 2, height: 60, color: const Color(0xFFFFF9C4)),
          ],
        ),
        const SizedBox(width: 15),

        // 2. 내용
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // 인용구 배경 (디자인에 따라 조정 가능)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDE7), // 아주 연한 노랑
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "\"${data['sentence'] ?? ""}\"",
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
                  ),
                  // 더보기 버튼 (우측 상단)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          OptionSheet(
                            type: 'highlight',
                            onDelete: onDelete,
                            onCreateMemo: onCreateMemo,
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("p.${data['page']}", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(
                    data['created_date']?.toString().substring(0, 10) ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}