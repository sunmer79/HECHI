import 'package:get/get.dart';
import 'package:http/http.dart' as http; // http 패키지 import
import 'dart:convert'; // jsonDecode용

class MainpageController extends GetxController {
  // Today Highlight 데이터
  final RxString highlightQuote =
      '수소와 산소에 마법적인 요소는 아무것도 없습니다. 당연히 지구의 생명체에는 그 물이 필요하겠죠. 하지만 다른 행성은 환경이 완전히 다를 수 있어요.'.obs;

  final RxString highlightBookTitle = '프로젝트 헤일메리'.obs;
  final RxString highlightAuthor = '앤디 위어'.obs;

  final RxString highlightImageUrl = 'https://picsum.photos/118/177?random=99'.obs;
  final RxString highlightRating = '4.9'.obs;

  // 상단 헤더 정보
  final RxString headerLogo = 'HECHI'.obs;
  final RxString userProfileUrl = 'https://picsum.photos/30/30'.obs;

  // 하단 탭 아이콘 (더미 유지)
  final RxString iconHome = 'https://picsum.photos/30/30?random=10'.obs;
  final RxString iconSearch = 'https://picsum.photos/30/30?random=11'.obs;
  final RxString iconReward = 'https://picsum.photos/30/30?random=12'.obs;
  final RxString iconMyRead = 'https://picsum.photos/30/30?random=13'.obs;

  // 인기 순위 리스트 (API 데이터로 채워짐)
  final RxList<Map<String, dynamic>> popularBookList = <Map<String, dynamic>>[].obs;

  // 검색 순위 리스트
  final RxList<Map<String, dynamic>> trendingBookList = <Map<String, dynamic>>[].obs;

  // 로딩 상태 관리
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularBooks(); // API 호출
    fetchTrendingBooks();
  }

  // 인기 순위 API 호출 함수
  Future<void> fetchPopularBooks() async {
    isLoading.value = true;
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/popular?days=30&limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 사용
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];

        popularBookList.value = items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;

          // 저자 리스트 처리 (null이면 '저자 미상')
          List<dynamic>? authorsList = item['authors'];
          String authorName = (authorsList != null && authorsList.isNotEmpty)
              ? authorsList.join(', ')
              : '저자 미상';

          // 이미지 처리 (null이면 더미 이미지 사용)
          String imageUrl = item['thumbnail'] ?? 'https://via.placeholder.com/118x177.png?text=No+Image';

          // 평점 처리 (null이면 0.0)
          String rating = (item['google_rating'] ?? 0.0).toString();

          return {
            'rank': index + 1,
            'title': item['title'] ?? '제목 없음',
            'rating': rating,
            'author': authorName,
            'imageUrl': imageUrl,
          };
        }).toList();

      } else {
        print('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 검색 순위 API 함수
  Future<void> fetchTrendingBooks() async {
    // 로딩 상태는 공유하거나 별도로 둬도 되지만, 여기선 조용히 백그라운드 로딩처럼 처리
    const String apiUrl = 'https://api.43-202-101-63.sslip.io/recommend/trending-search?days=30&limit=20';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];

        trendingBookList.value = items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;

          List<dynamic>? authorsList = item['authors'];
          String authorName = (authorsList != null && authorsList.isNotEmpty)
              ? authorsList.join(', ')
              : '저자 미상';

          String imageUrl = item['thumbnail'] ?? 'https://via.placeholder.com/118x177.png?text=No+Image';
          String rating = (item['google_rating'] ?? 0.0).toString();

          return {
            'rank': index + 1,
            'title': item['title'] ?? '제목 없음',
            'rating': rating,
            'author': authorName,
            'imageUrl': imageUrl,
          };
        }).toList();
      } else {
        print('Trending API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Trending Network Error: $e');
    }
  }
}
