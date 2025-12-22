import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/reading_library_model.dart';
import '../controllers/reading_registration_controller.dart';

class CurrentReadingBookWidget extends StatelessWidget {
  final ReadingLibraryItem? item;

  const CurrentReadingBookWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  String _formatTime(int seconds) {
    if (seconds == 0) return "0분";
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    if (seconds >= 3600) return "$h:$m:$s";
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReadingRegistrationController>();

    // 1. 선택된 책이 없을 때 (Placeholder)
    if (item == null) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 40, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "아래 목록에서 책을 선택하여\n독서를 시작하세요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final book = item!.book;
    final int totalPages = book.totalPages > 0 ? book.totalPages : 1;
    final double progressValue = (item!.progressPercent / 100).clamp(0.0, 1.0);

    return Obx(() {
      // 현재 이 책이 '세션 진행 중'인 책인지 확인
      bool isReadingNow = controller.currentSession.value?.bookId == book.id;

      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // [상단] 책 정보 영역
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 책 표지
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.thumbnail,
                      width: 90,
                      height: 135,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 135,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // 우측 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 제목
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // 퍼센트 바
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.grey[200],
                          color: isReadingNow ? Colors.blueAccent : Colors.black,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 완독률 | 페이지
                      Text(
                        "${item!.progressPercent}% | ${item!.currentPage}p",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 독서 시간 (타이머)
                      Row(
                        children: [
                          Icon(Icons.access_time_filled, size: 14,
                              color: isReadingNow ? Colors.blueAccent : Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            isReadingNow
                                ? _formatTime(controller.elapsedSeconds.value)
                                : "0분",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isReadingNow ? FontWeight.bold : FontWeight.normal,
                              color: isReadingNow ? Colors.blueAccent : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 10),

            if (isReadingNow) ...[
              // Case 1: 독서 중일 때 (그만 읽기 버튼만 표시)
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => controller.showStopDialog(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    backgroundColor: Colors.redAccent.withOpacity(0.1), // 빨간 배경색 은은하게 추가
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.stop_rounded, size: 26),
                  label: const Text(
                    "그만 읽기",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ] else ...[
              // Case 2: 독서 중이 아닐 때 (독서 시작 버튼)
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => controller.onBookTap(book.id),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.blueAccent.withOpacity(0.05),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 26),
                  label: const Text(
                    "독서 시작",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]
          ],
        ),
      );
    });
  }
}