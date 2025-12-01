import 'package:get/get.dart';
import '../models/library_book_model.dart';

class BookStorageProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<List<LibraryBookModel>> getLibraryBooks({
    required String shelf,
    required String sort,
  }) async {
    // TODO: 로그인 후 저장된 실제 토큰으로 교체 필요
    String token = "YOUR_ACCESS_TOKEN_HERE";

    final response = await get(
      '/library/',
      query: {
        'shelf': shelf,
        'sort': sort,
        'limit': '50',
        'offset': '0',
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.status.hasError) {
      return [];
    }

    final data = response.body;
    if (data != null && data['items'] != null) {
      return (data['items'] as List)
          .map((item) => LibraryBookModel.fromJson(item))
          .toList();
    }

    return [];
  }
}