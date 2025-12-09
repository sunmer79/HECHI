import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainpageController extends GetxController {
  final RxString highlightQuote =
      '수소와 산소에 마법적인 요소는 아무것도 없습니다. 당연히 지구의 생명체에는 그 물이 필요하겠죠. 하지만 다른 행성은 환경이 완전히 다를 수 있어요.'.obs;
  final RxString highlightBookTitle = '프로젝트 헤일메리'.obs;
  final RxString highlightAuthor = '앤디 위어'.obs;
  final RxString headerLogo = 'HECHI'.obs;
  final RxString userProfileUrl = 'https://picsum.photos/30/30'.obs;
  final RxList<Map<String, dynamic>> popularBookList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> trendingBookList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> curationList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> currentThemeBooks = <Map<String, dynamic>>[].obs;
  final RxString currentThemeTitle = ''.obs;
  final RxBool isThemeLoading = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchPopularBooks();
    fetchTrendingBooks();
    fetchCurations();
  }

  Future<void> fetchPopularBooks() async {
    isLoading.value = true;
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/popular?days=30&limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];

        popularBookList.value = items.asMap().entries.map((entry) {
          var book = _parseBookItem(entry.value);
          book['rank'] = entry.key + 1;
          return book;
        }).toList();
      } else {
        print('Popular API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Popular Network Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTrendingBooks() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/trending-search?days=30&limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];

        trendingBookList.value = items.asMap().entries.map((entry) {
          var book = _parseBookItem(entry.value);
          book['rank'] = entry.key + 1;
          return book;
        }).toList();
      } else {
        print('Trending API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Trending Network Error: $e');
    }
  }

  Future<void> fetchCurations() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/curations';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> curations = data['curations'];

        curationList.value = curations.map((curation) {
          String themeTitle = curation['title'] ?? '추천 테마';
          List<dynamic> items = curation['items'] ?? [];

          List<Map<String, dynamic>> books = items.map((item) {
            return _parseBookItem(item);
          }).toList().cast<Map<String, dynamic>>();

          return {
            'title': themeTitle,
            'books': books,
          };
        }).toList();
      } else {
        print('Curation API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Curation Network Error: $e');
    }
  }

  Future<void> fetchThemeDetail(String themeTitle) async {
    isThemeLoading.value = true;
    currentThemeTitle.value = themeTitle;
    currentThemeBooks.clear();

    final String encodedTheme = Uri.encodeComponent(themeTitle);
    final String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/curations/$encodedTheme?limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];

        currentThemeBooks.value = items.map((item) {
          return _parseBookItem(item);
        }).toList();
      } else {
        print('Theme Detail API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Theme Detail Network Error: $e');
    } finally {
      isThemeLoading.value = false;
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
      }
      else if (rawRating is String) {
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