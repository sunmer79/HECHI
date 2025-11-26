import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap; // [New] 클릭 이벤트 추가

  const FaqTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 클릭 시 실행
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: const Color(0xFFABABAB), width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // 텍스트가 길어질 경우를 대비해 Expanded 추가
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF3F3F3F),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis, // 말줄임표 처리
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFABABAB)),
          ],
        ),
      ),
    );
  }
}