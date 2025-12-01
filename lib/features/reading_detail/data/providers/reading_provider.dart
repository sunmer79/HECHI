import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/reading_session_model.dart';

class ReadingProvider extends GetConnect {
  final box = GetStorage();

  ReadingProvider() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<List<ReadingSessionModel>> getSessions(int bookId) async {
    String token = box.read('access_token') ?? '';

    if (token.isEmpty) {
      return [];
    }

    final response = await get(
      '/reading/sessions',
      query: {
        'book_id': bookId.toString(),
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.status.hasError) {
      return [];
    } else {
      List<dynamic> body = response.body;
      return body.map((json) => ReadingSessionModel.fromJson(json)).toList();
    }
  }
}