import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt currentIndex = 0.obs;

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void changeIndex(int index) {
    if (currentIndex.value == index) {
      resetHistory(index);
    } else {
      currentIndex(index);
    }
  }

  void resetHistory(int index) {
    final key = navigatorKeys[index];

    if (key.currentState != null && key.currentState!.canPop()) {
      key.currentState!.popUntil((route) => route.isFirst);
    }
  }
}