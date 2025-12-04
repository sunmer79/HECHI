import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';

class AppController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  // 하단바 인덱스 관리
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // 🚀 앱 실행 시 호출되는 자동 로그인 체크 함수
  Future<void> checkAutoLogin() async {
    print("🔄 앱 시작: 자동 로그인 여부 확인 중...");

    // 1. 사용자가 '자동 로그인'을 체크했었는지 확인
    bool isAutoLoginEnabled = box.read('is_auto_login') ?? false;
    String? accessToken = box.read('access_token');

    // 자동 로그인을 안 켰거나, 토큰이 없으면 -> 로그인 페이지로
    if (!isAutoLoginEnabled || accessToken == null) {
      print("⚠️ 자동 로그인 설정 안됨 or 토큰 없음 -> 로그인 페이지 이동");
      await Future.delayed(const Duration(milliseconds: 1000)); // 스플래시 노출용 딜레이
      Get.offAllNamed(Routes.login);
      return;
    }

    // 2. 토큰 유효성 검사 (서버에 확인)
    try {
      final meUrl = Uri.parse('$baseUrl/auth/me');
      final response = await http.get(
        meUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        print("✅ 자동 로그인 성공! (토큰 유효)");
        final meData = jsonDecode(utf8.decode(response.bodyBytes));

        // 취향 분석 여부에 따라 라우팅
        bool isAnalyzed = meData['taste_analyzed'] ?? false;
        if (isAnalyzed) {
          Get.offAllNamed(Routes.initial); // 메인으로
        } else {
          Get.offAllNamed(Routes.preference); // 취향 분석으로
        }
      } else {
        print("❌ 토큰 만료됨 (${response.statusCode}) -> 로그인 페이지 이동");
        // 토큰이 만료되었으므로 자동 로그인 해제
        box.write('is_auto_login', false);
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      print("🚨 통신 오류: $e -> 로그인 페이지 이동");
      Get.offAllNamed(Routes.login);
    }
  }
}