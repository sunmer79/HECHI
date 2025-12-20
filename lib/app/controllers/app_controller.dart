import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';

class AppController extends GetxController {
  final box = GetStorage();
  final String baseUrl = "https://api.43-202-101-63.sslip.io";

  RxInt currentIndex = 0.obs;

  // 앱 전체에서 공유할 내 정보 변수
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // ✅ [수정] 기본 멘트로 초기화
  final RxString description = "나만의 소개글을 입력해주세요!".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // 내 정보 가져오기 (GET /auth/me)
  Future<void> fetchUserProfile() async {
    String? token = box.read('access_token');
    if (token == null) return;

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/auth/me'),
          headers: {"Authorization": "Bearer $token"}
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        userProfile.value = data;

        // ✅ [핵심 로직] 서버 데이터가 비어있으면 -> 기본 멘트 표시
        String serverDesc = data['description'] ?? "";
        if (serverDesc.trim().isEmpty) {
          description.value = "나만의 소개글을 입력해주세요!";
        } else {
          description.value = serverDesc;
        }

        print("✅ 내 정보 로드 완료: ${userProfile['nickname']} / ${description.value}");
      }
    } catch (e) {
      print("Global Profile Error: $e");
    }
  }

  // 프로필 수정 요청 (PATCH /auth/me)
  Future<bool> updateUserProfile(String newNickname, String newDesc) async {
    String? token = box.read('access_token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/auth/me');

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "nickname": newNickname,
          "description": newDesc,
        }),
      );

      if (response.statusCode == 200) {
        // 성공 시 로컬 변수 갱신
        userProfile['nickname'] = newNickname;
        userProfile['description'] = newDesc;

        // ✅ [UI 갱신] 지우고 저장했으면 다시 기본 멘트로 돌아가게 설정
        if (newDesc.trim().isEmpty) {
          description.value = "나만의 소개글을 입력해주세요!";
        } else {
          description.value = newDesc;
        }

        userProfile.refresh();

        print("✅ 서버 프로필 업데이트 성공!");
        return true;
      } else {
        print("❌ 서버 업데이트 실패: ${response.statusCode}");
        Get.snackbar("오류", "저장에 실패했습니다.");
        return false;
      }
    } catch (e) {
      print("🚨 통신 오류: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.");
      return false;
    }
  }

  // 자동 로그인 체크
  Future<void> checkAutoLogin() async {
    print("🔄 앱 시작: 자동 로그인 여부 확인 중...");

    bool isAutoLoginEnabled = box.read('is_auto_login') ?? false;
    String? accessToken = box.read('access_token');

    if (!isAutoLoginEnabled || accessToken == null) {
      await Future.delayed(const Duration(milliseconds: 1000));
      Get.offAllNamed(Routes.login);
      return;
    }

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
        print("✅ 자동 로그인 성공!");
        final meData = jsonDecode(utf8.decode(response.bodyBytes));
        userProfile.value = meData;

        // ✅ [핵심 로직] 여기도 동일하게 적용
        String serverDesc = meData['description'] ?? "";
        if (serverDesc.trim().isEmpty) {
          description.value = "나만의 소개글을 입력해주세요!";
        } else {
          description.value = serverDesc;
        }

        bool isAnalyzed = meData['taste_analyzed'] ?? false;
        if (isAnalyzed) {
          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }
      } else {
        box.write('is_auto_login', false);
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      Get.offAllNamed(Routes.login);
    }
  }
}