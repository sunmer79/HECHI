import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'book_model.dart';

// 히스토리 데이터 모델 (ID와 검색어 저장)
class SearchHistoryItem {
  final int id;
  final String query;

  SearchHistoryItem({required this.id, required this.query});

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] ?? 0,
      query: json['query'] ?? '',
    );
  }
}

class SearchRepository {
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  String get _token => GetStorage().read('access_token') ?? "";

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
  };

  // 1. 책 검색 (디버깅 모드)
  Future<List<Book>> searchBooks(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/search/query');
      print("🚀 [요청] POST $uri");
      print("📦 [데이터] query: $query");

      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          "query": query,
          "limit": 20,
          "save_history": true
        }),
      );

      print("📡 [응답 상태코드] ${response.statusCode}");

      if (response.statusCode == 200) {
        // 한글 깨짐 방지 디코딩
        final String decodedBody = utf8.decode(response.bodyBytes);
        print("📄 [서버 응답 원본]: $decodedBody"); // ★ 여기가 제일 중요합니다!

        final Map<String, dynamic> data = json.decode(decodedBody);

        // 데이터 구조 확인
        if (data.containsKey('books')) {
          final List<dynamic> list = data['books'];
          print("✅ 'books' 리스트 발견! 개수: ${list.length}개");

          if (list.isEmpty) {
            print("⚠️ 근데 리스트가 비어있음 (검색 결과 없음)");
            return [];
          }

          try {
            return list.map((json) => Book.fromJson(json)).toList();
          } catch (e) {
            print("💥 [파싱 에러] Book 모델 변환 실패: $e");
            // 어떤 데이터 때문에 에러 났는지 확인
            print("💥 문제의 데이터: ${list.first}");
            return [];
          }
        } else {
          print("⚠️ 응답에 'books' 키가 없습니다. 현재 키 목록: ${data.keys.toList()}");
          return [];
        }
      } else {
        print("🚨 [서버 에러]: ${utf8.decode(response.bodyBytes)}");
        return [];
      }
    } catch (e) {
      print("🚨 [연결 실패]: $e");
      return [];
    }
  }

  // 2. 검색 기록 가져오기 (중복 제거 및 파싱)
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    try {
      final uri = Uri.parse('$baseUrl/search/history').replace(queryParameters: {'limit': '20'});
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final dynamic data = json.decode(decodedBody);

        if (data is List) {
          final List<SearchHistoryItem> allItems = data
              .map((json) => SearchHistoryItem.fromJson(json))
              .toList();

          final Set<String> seen = {};
          final List<SearchHistoryItem> uniqueItems = [];

          for (var item in allItems) {
            if (!seen.contains(item.query)) {
              seen.add(item.query);
              uniqueItems.add(item);
            }
          }

          return uniqueItems;
        }
        return [];
      }
      print("🚨 히스토리 에러: ${response.body}");
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

  // 4. 단건 삭제 API 연결 (DELETE /search/history/{id})
  Future<bool> deleteHistoryItem(int historyId) async {
    try {
      // URL 경로에 ID 포함
      final uri = Uri.parse('$baseUrl/search/history/$historyId');
      print("🗑️ 단건 삭제 요청: $uri");

      final response = await http.delete(uri, headers: _headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("🚨 단건 삭제 실패: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 단건 삭제 오류: $e");
      return false;
    }
  }

  // 5. 바코드 검색
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