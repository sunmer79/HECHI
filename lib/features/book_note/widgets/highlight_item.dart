import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_bottom_sheet.dart';
import '../widgets/overlays/creation_overlay.dart';

class HighlightItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const HighlightItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final memo = data["memo"] ?? "";
    final hasMemo = memo.toString().isNotEmpty;

    void showDetailOverlay() {
      Get.bottomSheet(
        CreationOverlay(
          type: "highlight",
          isEdit: true,
          isReadOnly: true,
          itemId: data['id'],
          page: data['page'],
          sentence: data['sentence'],
          memo: data['memo'],
          isPublic: data['is_public'],
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }

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
                  color: Color(0xFFFFF9C4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.push_pin_outlined, size: 16, color: Color(0xFFFBC02D)), // 진한 노랑
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
                        OptionBottomSheet(type: "highlight", data: data),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Icon(Icons.more_horiz, size: 20, color: Color(0xFFBDBDBD)),
                    ),
                  ),

                  GestureDetector(
                    onTap: showDetailOverlay,
                    child: Text(
                      "“${data["sentence"] ?? ""}”",
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3F3F3F),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "p.${data["page"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    _formatDate(data["created_date"]),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),

                  if (hasMemo) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: showDetailOverlay,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          border: Border(
                            left: BorderSide(
                              color: const Color(0xFFFBC02D).withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          memo,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3F3F3F),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
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
      /*
      String period = date.hour >= 12 ? "오후" : "오전";
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} $period ${date.hour}시 ${date.minute}분";
       */
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return raw;
    }
  }
}
