import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/library_book_model.dart';

class BookStorageProvider extends GetConnect {

  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<List<LibraryBookModel>> getLibraryBooks({
    required String shelf,
    required String sort,
  }) async {

    String token = box.read('access_token') ?? '';

    if (token.isEmpty) {
      print("🚨 토큰이 없어 도서 보관함 정보를 가져올 수 없습니다. 로그인이 필요합니다.");
      return [];
    }

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
      print("❌ 도서 보관함 조회 API 오류: ${response.statusText}");
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