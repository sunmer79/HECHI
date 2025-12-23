import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpLogo extends StatelessWidget {
  const SignUpLogo({super.key});

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