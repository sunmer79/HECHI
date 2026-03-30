import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hechi/app/main_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes.dart';
import 'app/bindings/app_binding.dart';

// ✅ 1. 파이어베이스 옵션 파일 임포트 추가
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ✅ 2. 백그라운드 초기화에도 옵션 추가
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("🔥 백그라운드 알림 수신: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 3. 메인 초기화에도 옵션 추가 (이게 없어서 크롬에서 뻗었던 겁니다!)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await setupFirebaseMessaging();

  await GetStorage.init();
  runApp(const MyApp());
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('✅ 알림 권한 상태: ${settings.authorizationStatus}');

  try {
    String? token = await messaging.getToken();
    print('====================================');
    print('🔥 내 기기의 FCM 토큰: $token');
    print('====================================');
  } catch (e) {
    print('❌ FCM 토큰 발급 오류: $e');
  }

  messaging.onTokenRefresh.listen((newToken) {
    print('🔥 FCM 토큰 갱신됨: $newToken');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HECHI App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4DB56C),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialBinding: AppBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}