import 'package:get/get.dart';
import '../models/reading_session_model.dart';

class ReadingProvider extends GetConnect {
  ReadingProvider() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<List<ReadingSessionModel>> getSessions() async {
    final response = await get('/reading/sessions');

    if (response.status.hasError) {
      print("Reading API Error: ${response.statusText}");
      return [];
    } else {
      List<dynamic> body = response.body;
      return body.map((json) => ReadingSessionModel.fromJson(json)).toList();
    }
  }
}