import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CsProvider extends GetConnect {
  final _box = GetStorage();

  final String _baseUrl = 'https://api.43-202-101-63.sslip.io';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;

    httpClient.addRequestModifier<void>((request) async {
      final token = _box.read('access_token');

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.headers['Content-Type'] = 'application/json';

      return request;
    });
  }

  Future<Response> getFaqs() => get('/support/faqs');

  Future<Response> getMyTickets() => get('/support/tickets/me');

  Future<Response> createTicket(String title, String content) {
    final body = {
      'title': title,
      'description': content,
    };
    return post('/support/tickets', body);
  }
}