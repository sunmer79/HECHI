import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarController extends GetxController {
  final box = GetStorage();

  // API 주소
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 캘린더 상태 변수
  RxInt currentYear = DateTime.now().year.obs;
  RxInt currentMonth = DateTime.now().month.obs;

  // API 데이터 변수
  RxInt totalReadCount = 0.obs;
  RxString topGenre = "".obs;

  // 1. 달력 그리드에 보여줄 표지 (Key: 날짜, Value: 썸네일 URL)
  RxMap<int, String> calendarBooks = <int, String>{}.obs;

  // 2. 바텀 시트에 보여줄 상세 리스트 (Key: 날짜, Value: 책 정보 리스트)
  RxMap<int, List<dynamic>> dailyBooks = <int, List<dynamic>>{}.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCalendarData();
  }

  // 월 변경 함수
  void changeMonth(int offset) {
    DateTime newDate = DateTime(currentYear.value, currentMonth.value + offset);
    currentYear.value = newDate.year;
    currentMonth.value = newDate.month;
    fetchCalendarData();
  }

  // API 호출
  Future<void> fetchCalendarData() async {
    String? token = box.read('access_token');

    // 토큰이 없으면 요청하지 않음
    if (token == null) {
      print("🚨 [Calendar] 토큰 없음. 로그인이 필요합니다.");
      return;
    }

    isLoading.value = true;

    // 1. URL 생성 (API 문서: GET /analytics/calendar-month?year=...&month=...)
    final queryParams = {
      'year': currentYear.value.toString(),
      'month': currentMonth.value.toString(),
    };

    final url = Uri.parse('$baseUrl/analytics/calendar-month').replace(queryParameters: queryParams);

    print('🔵 [API 요청] URL: $url');

    try {
      // 2. HTTP GET 요청
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('🟢 [API 응답] 상태 코드: ${response.statusCode}');

      // 3. 응답 처리
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('✅ 데이터 수신 성공: $data');

        // 3-1. 요약 정보 파싱
        totalReadCount.value = data['total_read_count'] ?? 0;
        topGenre.value = data['top_genre'] ?? "-";

        // 3-2. 날짜별 책 정보 파싱
        Map<int, String> newCovers = {};      // 표지용 임시 맵
        Map<int, List<dynamic>> newDaily = {}; // 상세 리스트용 임시 맵

        List days = data['days'] ?? [];

        for (var dayData in days) {
          try {
            // 날짜 파싱
            String dateStr = dayData['date'];
            DateTime date = DateTime.parse(dateStr);
            List items = dayData['items'] ?? []; // 해당 날짜의 책 목록

            if (items.isNotEmpty) {
              // (1) 표지 저장: 첫 번째 책의 썸네일 사용
              String? thumbnail = items[0]['thumbnail'];
              if (thumbnail != null && thumbnail.isNotEmpty) {
                newCovers[date.day] = thumbnail;
              }

              // (2) 상세 리스트 저장: 바텀 시트용으로 전체 리스트 저장
              // (title, authors, rating 등이 포함되어 있어야 함)
              newDaily[date.day] = items;
            }
          } catch (e) {
            print("⚠️ 날짜 데이터 파싱 중 에러: $e");
          }
        }

        // UI 업데이트
        calendarBooks.value = newCovers;
        dailyBooks.value = newDaily; // ✅ 상세 데이터 업데이트됨

        print('✅ 캘린더 데이터 갱신 완료 (총 ${newCovers.length}일치 표지, ${newDaily.length}일치 상세 데이터)');

      } else {
        print("❌ 요청 실패: ${response.statusCode}");
        print("에러 메시지: ${utf8.decode(response.bodyBytes)}");
      }
    } catch (e) {
      print("🚨 네트워크 오류 발생: $e");
    } finally {
      isLoading.value = false;
    }
  }
}