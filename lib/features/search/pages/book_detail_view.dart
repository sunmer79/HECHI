import 'package:flutter/material.dart';
import '../data/book_model.dart';

class BookDetailView extends StatelessWidget {
  final Book book;
  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("도서 상세 정보", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 140, height: 200,
                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
                child: (book.thumbnail != null)
                    ? Image.network(book.thumbnail!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200], child: const Icon(Icons.book, size: 50, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 30),
            Text(book.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(book.authorString, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            _buildInfoRow("출판사", book.publisher ?? '-'),
            _buildInfoRow("출판일", book.publishedDate ?? '-'),
            _buildInfoRow("카테고리", book.category ?? '-'),
            _buildInfoRow("ISBN", book.isbn ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black))),
        ],
      ),
    );
  }
}