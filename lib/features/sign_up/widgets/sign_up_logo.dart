import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpLogo extends StatelessWidget {
  const SignUpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'HECHI',
      style: GoogleFonts.sedgwickAveDisplay(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4DB56C),
        letterSpacing: 1.5,
      ),
    );
  }
}