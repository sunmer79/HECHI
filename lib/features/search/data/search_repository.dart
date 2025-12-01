import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book_model.dart';

class SearchRepository {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // [임시 토큰] 만료되면 로그인해서 새로 받아야 함
  final String _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNyIsImlhdCI6MTc2NDUxNzI1OSwiZXhwIjoxNzY0NTE5MDU5LCJ0eXBlIjoiYWNjZXNzIiwianRpIjoiYjY1MjA2Y2ZkM2JlNDZjNWJmOWJkNDlkMjQxMjFiN2YifQ.Xrqm883__YiF-be3TNPHJJGQOIL1761ZiqHoJThAwE4";

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
  };

  // 1. 책 검색
  Future<List<Book>> searchBooks(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/search/query');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({"query": query, "limit": 20}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data.containsKey('items')) {
          return (data['items'] as List).map((json) => Book.fromJson(json)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print("🚨 검색 실패: $e");
      return [];
    }
  }

  // 2. 검색 기록 가져오기 (중복 제거 및 파싱)
  Future<List<String>> getSearchHistory() async {
    try {
      final uri = Uri.parse('$baseUrl/search/history').replace(queryParameters: {'limit': '20'});
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final dynamic data = json.decode(decodedBody);

        if (data is List) {
          final List<String> rawList = data.map((item) {
            final mapItem = item as Map<String, dynamic>;
            return (mapItem['query'] ?? "").toString();
          }).toList();
          return rawList.toSet().toList(); // 중복 제거
        }
        return [];
      }
      return [];
    } catch (e) {
      print("🚨 히스토리 실패: $e");
      return [];
    }
  }

  // 3. 전체 삭제
  Future<bool> deleteAllHistory() async {
    try {
      final uri = Uri.parse('$baseUrl/search/history');
      final response = await http.delete(uri, headers: _headers);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. 바코드 검색
  Future<Book?> searchByBarcode(String isbn) async {
    try {
      final uri = Uri.parse('$baseUrl/search/barcode').replace(queryParameters: {
        'isbn': isbn, 'auto_import': 'true',
      });
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data.containsKey('book')) return Book.fromJson(data['book']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}