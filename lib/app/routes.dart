import 'package:flutter/material.dart';

// 페이지 임시 예시 — 나중에 네 페이지로 교체
import 'package:hechi/features/home/home_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => HomePage(),
};
