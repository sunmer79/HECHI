import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart'; // ✅ 토큰 사용을 위해 추가

class MainpageController extends GetxController {
  // --- 기존 변수들 ---
  final RxString highlightQuote = '오늘의 문장을 불러오는 중입니다...'.obs;
  final RxString highlightBookTitle = ''.obs;
  final RxString highlightAuthor = ''.obs;
  final RxInt highlightBookId = 0.obs; // 0이면 클릭 안되게 하거나 예외처리
  final RxString headerLogo = 'HECHI'.obs;
  final RxString userProfileUrl = 'https://picsum.photos/30/30'.obs;

  // --- 리스트 데이터 ---
  final RxList<Map<String, dynamic>> popularBookList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> trendingBookList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> curationList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> currentThemeBooks = <Map<String, dynamic>>[].obs;

  // ✅ [NEW] 새로 추가된 섹션 데이터
  final RxList<Map<String, dynamic>> bestsellerList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> newBookList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> genreBestsellerList = <Map<String, dynamic>>[].obs;

  final RxString currentThemeTitle = ''.obs;
  final RxBool isThemeLoading = false.obs;
  final RxBool isLoading = false.obs;

  // ✅ [NEW] 토큰 및 헤더 헬퍼 (API 호출 시 인증 필요)
  String get _token => GetStorage().read('access_token') ?? "";
  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
  };

  @override
  void onReady() {
    super.onReady();
    // 기존 API 호출
    fetchPopularBooks();
    fetchTrendingBooks();
    fetchCurations();

    // ✅ [NEW] 신규 API 호출
    fetchBestsellers();
    fetchNewBooks();
    fetchGenreBestsellers();
    fetchRandomHighlight();
  }
  Future<void> fetchRandomHighlight() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/highlights/random-public';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // 🔍 [로그 추가] 서버에서 온 전체 데이터와 ID 확인
        print("📢 [Highlight API] 전체 데이터: $data");
        print("📢 [Highlight API] book_id: ${data['book_id']}");

        highlightBookId.value = data['book_id'] ?? 0;
        highlightBookTitle.value = data['title'] ?? '';
        highlightAuthor.value = data['author'] ?? '';
        highlightQuote.value = data['sentence'] ?? '문장이 없습니다.';

      } else {
        print('Highlight API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Highlight Network Error: $e');
    }
  }
  // 1. 인기 순위 API
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

  // 2. 검색 순위 API
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

  // 3. 큐레이션(테마) 목록 API
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

  // 4. 테마 상세 API
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

  // ✅ 5. [NEW] 전체 베스트셀러 API 구현
  Future<void> fetchBestsellers() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/bestseller?limit=10';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        bestsellerList.value = items.map((item) => _parseBookItem(item)).toList().cast<Map<String, dynamic>>();
      } else {
        print('Bestseller API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Bestseller Network Error: $e');
    }
  }

  // ✅ 6. [NEW] 신간 도서 API 구현
  Future<void> fetchNewBooks() async {
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/new?limit=10';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        newBookList.value = items.map((item) => _parseBookItem(item)).toList().cast<Map<String, dynamic>>();
      } else {
        print('New Books API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('New Books Network Error: $e');
    }
  }

  // ✅ 7. [NEW] 장르별 베스트셀러 API 구현 (User ID 필요)
  Future<void> fetchGenreBestsellers() async {
    try {
      // (1) 내 정보 API를 호출해서 User ID 가져오기
      final meResponse = await http.get(
          Uri.parse('https://api.43-202-101-63.sslip.io/auth/me'),
          headers: _headers
      );

      if (meResponse.statusCode != 200) {
        print("Auth Me Error: ${meResponse.statusCode}");
        return;
      }

      int userId = jsonDecode(utf8.decode(meResponse.bodyBytes))['id'];

      // (2) 가져온 User ID로 장르별 베스트셀러 호출
      final String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/genre-bestseller?user_id=$userId&limit=10';
      final response = await http.get(Uri.parse(apiUrl), headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> curations = data['curations'];

        genreBestsellerList.value = curations.map((section) {
          return {
            'title': section['title'] ?? '추천 장르',
            'books': (section['items'] as List).map((item) => _parseBookItem(item)).toList().cast<Map<String, dynamic>>(),
          };
        }).toList();
      } else {
        print('Genre Bestseller API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Genre Bestseller Network Error: $e');
    }
  }

  // 공통 책 데이터 파싱 헬퍼 (평점 소수점 처리 포함)
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