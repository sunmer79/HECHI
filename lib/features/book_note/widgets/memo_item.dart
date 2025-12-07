import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_sheet.dart';

class MemoItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  const MemoItem({super.key, required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.description_outlined, color: Color(0xFFEF5350), size: 20),
            ),
            Container(width: 2, height: 60, color: const Color(0xFFFFEBEE)),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFEEEEEE))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(data['content'] ?? "", style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87))),
                    GestureDetector(
                      onTap: () => Get.bottomSheet(OptionSheet(type: 'memo', onDelete: onDelete), backgroundColor: Colors.transparent),
                      child: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Text("p.${data['page']}", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(data['created_date']?.toString().substring(0, 10) ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}