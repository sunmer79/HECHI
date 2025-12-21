import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_bottom_sheet.dart';
import '../widgets/overlays/creation_overlay.dart';

class MemoItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const MemoItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String content = data["content"] ?? "";
    final String date = _formatDate(data["created_date"]);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description_outlined, size: 16, color: Color(0xFFEF5350)), // 진한 빨강 아이콘
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: const Color(0xFFF3F3F3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.bottomSheet(
                        OptionBottomSheet(type: "memo", data: data),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Icon(Icons.more_horiz, size: 20, color: Color(0xFFBDBDBD)),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        CreationOverlay(
                          type: "memo",
                          isEdit: true,
                          isReadOnly: true,
                          itemId: data['id'],
                          content: content,
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        border: Border(
                          left: BorderSide(
                            color: const Color(0xFFEF5350).withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        content,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3F3F3F),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 날짜
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return "";
    try {
      final date = DateTime.parse(raw);
      String period = date.hour >= 12 ? "오후" : "오전";
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} $period ${date.hour}시 ${date.minute}분";
    } catch (e) {
      return raw;
    }
  }
}
