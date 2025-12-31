import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonCalendarWidget extends StatelessWidget {
  final int currentYear;
  final int currentMonth;
  final Map<int, String> bookCovers;
  final Map<int, List<dynamic>> dailyBooks;

  const CommonCalendarWidget({
    super.key,
    required this.currentYear,
    required this.currentMonth,
    required this.bookCovers,
    required this.dailyBooks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekdayText('Sun', color: Colors.red),
              _WeekdayText('Mon', color: Colors.black87),
              _WeekdayText('Tue', color: Colors.black87),
              _WeekdayText('Wed', color: Colors.black87),
              _WeekdayText('Thu', color: Colors.black87),
              _WeekdayText('Fri', color: Colors.black87),
              _WeekdayText('Sat', color: Colors.blue),
            ],
          ),
        ),
        _buildCalendarGrid(context),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: firstWeekday + daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.65,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox();

        final day = index - firstWeekday + 1;
        final hasBook = bookCovers.containsKey(day);
        final bookImageUrl = bookCovers[day];

        Color dayColor = Colors.grey[600]!;
        if (index % 7 == 0) dayColor = Colors.red;
        else if (index % 7 == 6) dayColor = Colors.blue;

        return GestureDetector(
          onTap: () {
            final books = dailyBooks[day] ?? [];
            _showDailyListSheet(context, day, books);
          },
          child: Column(
            children: [
              Text("$day", style: TextStyle(color: dayColor, fontSize: 13, fontWeight: FontWeight.w400)),
              const SizedBox(height: 6),
              Expanded(
                child: hasBook
                    ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      // ✅ [수정] withValues 사용
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      bookImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                    ),
                  ),
                )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDailyListSheet(BuildContext context, int day, List<dynamic> books) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              "$currentMonth월 ${day.toString().padLeft(2, '0')}일",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "${books.length} 작품을 감상했어요.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: books.isEmpty
                  ? const Center(child: Text("기록된 책이 없습니다."))
                  : ListView.separated(
                itemCount: books.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final book = books[index];
                  String title = book['title'] ?? '제목 없음';
                  String imgUrl = book['thumbnail'] ?? '';
                  String author = "작가 미상";

                  if (book['authors'] is List && (book['authors'] as List).isNotEmpty) {
                    author = book['authors'][0];
                  } else if (book['authors'] is String) {
                    author = book['authors'];
                  }

                  double rating = 0.0;
                  if (book['rating'] != null) {
                    rating = (book['rating'] is num) ? (book['rating'] as num).toDouble() : 0.0;
                  }

                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          imgUrl,
                          width: 50, height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 50, height: 75, color: Colors.grey[200]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(author, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                // ✅ [수정] withValues 사용
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 12, color: Colors.amber),
                                  const SizedBox(width: 3),
                                  Text("$rating", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _WeekdayText extends StatelessWidget {
  final String text;
  final Color color;
  const _WeekdayText(this.text, {required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold))));
  }
}