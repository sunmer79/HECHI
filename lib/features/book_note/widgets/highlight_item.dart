import 'package:flutter/material.dart';
import '../widgets/dialogs/option_sheet.dart';

class HighlightItem extends StatelessWidget {
  final int id;
  final int page;
  final String sentence;
  final String date;
  final VoidCallback onDelete;
  final VoidCallback onMemo;

  const HighlightItem({
    super.key,
    required this.id,
    required this.page,
    required this.sentence,
    required this.date,
    required this.onDelete,
    required this.onMemo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 17, right: 17),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 37,
                height: 37,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1ECD9),
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: const Color(0xFF4DB56C),
                ),
              ),
            ],
          ),
          const SizedBox(width: 21),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 페이지 + more
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'p.$page',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showOptionSheet(
                          context: context,
                          title: '하이라이트',
                          onDelete: onDelete,
                          onMemo: onMemo,
                          isMemo: false, // 메모 작성
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          size: 18,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    sentence,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3F3F3F),
                      height: 1.33,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF717171),
                      height: 1.54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
