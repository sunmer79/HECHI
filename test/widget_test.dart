import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 앱 코드 import
import 'package:hechi/app/main_app.dart';
import 'package:hechi/app/routes.dart';
import 'package:hechi/app/theme.dart';

// HomePage 임시 정의
import 'package:hechi/features/home/home_page.dart';

void main() {
  testWidgets('App loads and shows HomePage', (WidgetTester tester) async {
    // 앱 빌드
    await tester.pumpWidget(const MyApp());

    // HomePage 텍스트 확인
    expect(find.text('Home Page'), findsOneWidget);
  });
}
