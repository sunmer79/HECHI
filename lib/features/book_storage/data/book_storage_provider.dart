import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/library_book_model.dart';

class BookStorageProvider extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<List<LibraryBookModel>> getLibraryBooks({
    required String shelf,
    required String sort,
  }) async {
    String token = box.read('access_token') ?? '';

    if (token.isEmpty) {
      print("🚨 [Provider] 토큰이 없습니다.");
      return [];
    }

    final queryParams = {
      'shelf': shelf,
      'sort': sort,
      'limit': '50',
      'offset': '0',
    };

    try {
      final response = await get(
        '/library/',
        query: queryParams,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.status.hasError) {
        print("❌ [API Error] Status: ${response.statusCode}");
        print("❌ [Raw Server Message] ${response.bodyString}");
        return [];
      }

      final data = response.body;
      if (data != null && data['items'] != null) {
        return (data['items'] as List)
            .map((item) => LibraryBookModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print("‼️ [Provider Exception] $e");
    }
    return [];
  }
}