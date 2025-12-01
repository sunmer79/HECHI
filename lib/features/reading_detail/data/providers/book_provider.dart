import 'package:get/get.dart';
import '../models/book_detail_model.dart';

class BookProvider extends GetConnect {
  BookProvider() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<BookDetailModel?> getBookDetail(int bookId) async {
    final response = await get('/books/$bookId');

    if (response.status.hasError) {
      print("Book API Error: ${response.statusText}");
      return null;
    } else {
      return BookDetailModel.fromJson(response.body);
    }
  }
}