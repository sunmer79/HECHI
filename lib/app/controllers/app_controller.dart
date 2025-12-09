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

  // 소개글 (API에 필드가 없으므로 로컬 저장소 활용)
  final RxString description = "나만의 소개글을 입력해주세요!".obs;

  @override
  void onInit() {
    super.onInit();
    // 앱 켤 때 저장된 소개글 불러오기 (유지)
    description.value = box.read('user_description') ?? "나만의 소개글을 입력해주세요!";
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // 내 정보 가져오기 (GET)
  Future<void> fetchUserProfile() async {
    String? token = box.read('access_token');
    if (token == null) return;

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/auth/me'),
          headers: {"Authorization": "Bearer $token"}
      );
      if (response.statusCode == 200) {
        userProfile.value = jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("Global Profile Error: $e");
    }
  }

  // ✅ [핵심 수정] 프로필 수정 요청 (PATCH API 연동)
  // 함수 이름을 updateLocalProfile -> updateUserProfile로 변경
  Future<bool> updateUserProfile(String newNickname, String newDesc) async {
    String? token = box.read('access_token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/auth/me');

    try {
      // 1. 서버에 닉네임 수정 요청
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "nickname": newNickname,
        }),
      );

      if (response.statusCode == 200) {
        // 2. 성공 시 서버 응답으로 로컬 정보 갱신
        final updatedData = jsonDecode(utf8.decode(response.bodyBytes));
        userProfile.value = updatedData;

        // 3. 소개글은 로컬에 저장
        description.value = newDesc;
        box.write('user_description', newDesc);

        print("✅ 서버 프로필 업데이트 성공!");
        return true;
      } else {
        print("❌ 서버 업데이트 실패: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🚨 통신 오류 (임시 저장): $e");
      // API가 없거나 통신 실패 시에도 UI 테스트를 위해 로컬은 바꿔줍니다.
      userProfile['nickname'] = newNickname;
      userProfile.refresh();
      description.value = newDesc;
      return true;
    }
  }

  // 🚀 자동 로그인 체크 함수
  Future<void> checkAutoLogin() async {
    print("🔄 앱 시작: 자동 로그인 여부 확인 중...");

    bool isAutoLoginEnabled = box.read('is_auto_login') ?? false;
    String? accessToken = box.read('access_token');

    if (!isAutoLoginEnabled || accessToken == null) {
      print("⚠️ 자동 로그인 설정 안됨 or 토큰 없음 -> 로그인 페이지 이동");
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
        print("✅ 자동 로그인 성공! (토큰 유효)");
        final meData = jsonDecode(utf8.decode(response.bodyBytes));

        userProfile.value = meData; // 정보 갱신

        bool isAnalyzed = meData['taste_analyzed'] ?? false;
        if (isAnalyzed) {
          Get.offAllNamed(Routes.initial);
        } else {
          Get.offAllNamed(Routes.preference);
        }
      } else {
        print("❌ 토큰 만료됨 -> 로그인 페이지 이동");
        box.write('is_auto_login', false);
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      print("🚨 통신 오류: $e -> 로그인 페이지 이동");
      Get.offAllNamed(Routes.login);
    }
  }
}