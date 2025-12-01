import 'dart:convert';
import 'package:get/get.dart';

class CsProvider extends GetConnect {
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzY0MzQyNjgzLCJleHAiOjE3NjQzNDQ0ODMsInR5cGUiOiJhY2Nlc3MiLCJqdGkiOiJkMGRmOTBhZjI5Yzk0MDI3OWM0ZGVhZWNkODczZGE5MSJ9.82UdPfGjxEikQd0f5Yyyey48DgBsmrlT4x1DOMlIBmE';

  @override
  void onInit() {
    // 1. 인증서 에러 방지
    allowAutoSignedCert = true;

    // 2. 서버 주소 설정
    httpClient.baseUrl = 'https://43.202.101.63';

    // 3. 타임아웃 설정
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Response> getFaqs() => get('/support/faqs');

  // 내 문의 내역 조회
  Future<Response> getMyTickets() {
    return get(
      '/support/tickets/me',
      headers: {
        'Authorization': 'Bearer $_token', // 위에서 정의한 토큰 사용
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );
  }

  // 문의 등록
  Future<Response> createTicket(String title, String description) {
    final body = jsonEncode({
      'title': title,
      'description': description,
    });

    return post(
      '/support/tickets',
      body,
      headers: {
        'Authorization': 'Bearer $_token', // 위에서 정의한 토큰 사용
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
    );
  }
}