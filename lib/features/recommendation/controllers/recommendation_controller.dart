import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationController extends GetxController {
  final RxList<Map<String, dynamic>> recommendedBooks = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedBooks();
  }

  Future<void> fetchRecommendedBooks() async {
    isLoading.value = true;
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/personal?limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items']; // API 응답 구조에 맞게 수정

        recommendedBooks.value = items.map((item) {
          return _parseBookItem(item);
        }).toList();

      } else {
        print('Recommendation API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Recommendation Network Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 책 데이터 파싱 헬퍼 (MainpageController와 동일 로직)
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