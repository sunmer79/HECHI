import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_sheet.dart';
import '../widgets/overlays/bookmark_creation_overlay.dart';

class BookmarkItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  final Function(int bookmakrId, int page, String memo) onUpdate;

  const BookmarkItem({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 메모가 있는지 확인
    final String memoContent = data['memo'] ?? "";
    final bool hasMemo = memoContent.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.bookmark_border, color: Color(0xFF4DB56C), size: 20),
            ),
            Container(width: 2, height: 50, color: const Color(0xFFE8F5E9)),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("p.${data['page']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4DB56C))),

                  // 2. 더보기 버튼 클릭 시 로직
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        OptionSheet(
                          onDelete: onDelete,
                          actionLabel: hasMemo ? "메모 수정" : "메모 작성",

                          onAction: () {
                            Get.to(() => BookmarkCreationOverlay(
                                initialPage: data['page'],
                                initialMemo: memoContent,
                                onSubmit: (page, memo) {
                                  onUpdate(page, memo);
                                },
                              ),
                              fullscreenDialog: true,
                            );
                          },
                        ),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // const Text("97%", style: TextStyle(color: Colors.black54, fontSize: 13)), // 진행률 (데이터 없음)
              const SizedBox(height: 4),
              Text(data['created_date']?.toString().substring(0, 10) ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),

              // 3. 메모 내용 표시 (있을 때만)
              if (hasMemo) ...[
                const SizedBox(height: 8),
                Text(memoContent, style: const TextStyle(fontSize: 14, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]
            ],
          ),
        ),
      ],
    );
  }
}