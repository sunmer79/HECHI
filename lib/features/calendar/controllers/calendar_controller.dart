import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class CalendarController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 캘린더 상태 변수
  RxInt currentYear = DateTime.now().year.obs;
  RxInt currentMonth = DateTime.now().month.obs;

  // API 데이터 변수
  RxInt totalReadCount = 0.obs;        // 총 독서 권수
  RxString topGenre = "".obs;          // 가장 많이 읽은 장르
  RxMap<int, String> calendarBooks = <int, String>{}.obs; // 일자별 책 표지
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
    if (token == null) return;

    isLoading.value = true;
    final url = Uri.parse('$baseUrl/analytics/calendar-month?year=${currentYear.value}&month=${currentMonth.value}');

    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // 1. 요약 정보 파싱
        totalReadCount.value = data['total_read_count'] ?? 0;
        topGenre.value = data['top_genre'] ?? "";

        // 2. 날짜별 책 정보 파싱
        Map<int, String> newBooks = {};
        List days = data['days'] ?? [];

        for (var dayData in days) {
          String dateStr = dayData['date'];
          DateTime date = DateTime.parse(dateStr);
          List items = dayData['items'] ?? [];

          if (items.isNotEmpty) {
            String thumbnail = items[0]['thumbnail'] ?? "";
            if (thumbnail.isNotEmpty) {
              newBooks[date.day] = thumbnail;
            }
          }
        }
        calendarBooks.value = newBooks;
      }
    } catch (e) {
      print("Calendar Page Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}