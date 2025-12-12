import 'package:flutter/material.dart';

class OverlayCommon {
  static const headerStyle =
  TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  static const actionStyle =
  TextStyle(fontSize: 13, color: Colors.black);

  static InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
