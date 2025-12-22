import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HECHI",
        style: const TextStyle(

          fontFamily: 'MoveSans',
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4DB56C),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}