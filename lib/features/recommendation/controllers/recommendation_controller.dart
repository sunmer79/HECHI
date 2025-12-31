import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class RecommendationController extends GetxController {
  final RxList<Map<String, dynamic>> recommendedBooks = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString nickname = '회원'.obs;

  String get _token => GetStorage().read('access_token') ?? "";

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
  };

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
    fetchRecommendedBooks();
  }

  Future<void> fetchUserInfo() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/auth/me';

    try {
      if (_token.isEmpty) return; // 토큰 없으면 패스

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _headers, // 토큰 포함 헤더 사용
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // API 응답에서 nickname 가져오기 (없으면 기본값 유지)
        if (data['nickname'] != null) {
          nickname.value = data['nickname'];
          print("✅ 로그인 유저 닉네임: ${nickname.value}");
        }
      } else {
        print('User Info Error: ${response.statusCode}');
      }
    } catch (e) {
      print('User Info Network Error: $e');
    }
  }

  Future<void> fetchRecommendedBooks() async {
    isLoading.value = true;
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/for-you?limit=20&offset=0';

    try {
      if (_token.isEmpty) {
        print("🚨 [추천] 토큰이 없습니다. 로그인이 필요합니다.");
        isLoading.value = false;
        return;
      }

      print("🚀 [추천 요청] $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.containsKey('items')) {
          final List<dynamic> items = data['items'];

          recommendedBooks.value = items.map((item) {
            return _parseBookItem(item);
          }).toList();

          print("✅ [추천] 데이터 로드 성공: ${items.length}개");
        } else {
          recommendedBooks.clear();
          print("⚠️ [추천] items 키가 없습니다.");
        }

      } else if (response.statusCode == 403 || response.statusCode == 401) {
        print('🚨 [추천 권한 오류] ${response.statusCode}: 로그인이 만료되었거나 토큰이 잘못되었습니다.');
      } else {
        print('🚨 [추천 API 오류] ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('🚨 [추천 네트워크 오류]: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _parseBookItem(dynamic item) {
    List<dynamic>? authorsList = item['authors'];
    String authorName = (authorsList != null && authorsList.isNotEmpty)
        ? authorsList.join(', ')
        : '저자 미상';

    String imageUrl = item['thumbnail'] ?? 'https://via.placeholder.com/118x177.png?text=No+Image';

    var rawRating = item['average_rating'];
    String rating = '0.00';

    if (rawRating != null) {
      if (rawRating is num) {
        rating = rawRating.toDouble().toStringAsFixed(2);
      } else if (rawRating is String) {
        double? parsed = double.tryParse(rawRating);
        if (parsed != null) {
          rating = parsed.toStringAsFixed(2);
        }
      }
    }

    return {
      'id': item['id'],
      'title': item['title'] ?? '제목 없음',
      'rating': rating,
      'author': authorName,
      'imageUrl': imageUrl,
    };
  }
}