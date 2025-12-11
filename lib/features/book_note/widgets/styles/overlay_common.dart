import 'package:flutter/material.dart';

class OverlayCommon {
  static const headerStyle =
  TextStyle(fontSize: 17, fontWeight: FontWeight.w600);

  static const actionStyle =
  TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

  static InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
