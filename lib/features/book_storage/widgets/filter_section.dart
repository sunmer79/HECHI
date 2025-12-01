import 'package:flutter/material.dart';
import '../models/library_book_model.dart';

class BookGridItem extends StatelessWidget {
  final LibraryBookModel book;

  const BookGridItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 책 표지 이미지
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
              image: DecorationImage(
                image: NetworkImage(book.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
            // TODO: API 이미지 로딩 실패 시 처리 로직 추가 권장
          ),
        ),
        const SizedBox(height: 8),

        // 2. 책 제목
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),

        // 3. 별점 (상태에 따라 다르게 표시)
        if (book.myRating != null)
          Text(
            '평가함 ★${book.myRating}',
            style: const TextStyle(color: Color(0xFFFF7F00), fontSize: 12, fontWeight: FontWeight.bold),
          )
        else if (book.avgRating != null)
          Text(
            '예상 ★${book.avgRating}',
            style: const TextStyle(color: Color(0xFF4DB56C), fontSize: 12, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}