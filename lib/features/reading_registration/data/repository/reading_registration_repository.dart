import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/reading_library_model.dart';
import '../models/reading_registration_session_model.dart';

class ReadingRegistrationRepository extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.43-202-101-63.sslip.io';
  }

  Future<List<ReadingLibraryItem>> getLibraryReadingItems() async {
    String token = box.read('access_token') ?? '';

    if (token.isEmpty) {
      print("Token not found");
      return [];
    }

    final response = await get(
      '/library/',
      query: {
        'shelf': 'reading',
        'sort': 'latest',
        'limit': '50',
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.status.hasError) {
      print("Error fetching library items: ${response.statusText}");
      return [];
    }

    if (response.body != null) {
      final data = ReadingLibraryResponse.fromJson(response.body);
      return data.items.reversed.toList();
    }
    return [];
  }

  Future<ReadingRegistrationSession> startSession(int bookId, int? startPage) async {
    String token = box.read('access_token') ?? '';

    final response = await post(
      '/reading/sessions',
      {
        "book_id": bookId,
        if (startPage != null) "start_page": startPage
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.status.hasError) {
      print("세션 시작 실패: ${response.body}");
      throw Exception('Start session failed');
    }

    return ReadingRegistrationSession.fromJson(response.body);
  }

  Future<ReadingRegistrationSession> endSession(int sessionId, int endPage, int totalSeconds) async {
    String token = box.read('access_token') ?? '';

    final response = await post(
      '/reading/sessions/$sessionId/end',
      {
        "end_page": endPage,
        "total_seconds": totalSeconds
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.status.hasError) {
      print("세션 종료 실패: ${response.body}");
      throw Exception('End session failed');
    }

    return ReadingRegistrationSession.fromJson(response.body);
  }

  // (사용하지 않는다면 유지, 필요하다면 API 구현)
  Future<List<ReadingRegistrationSession>> getSessions() async {
    return [];
  }
}