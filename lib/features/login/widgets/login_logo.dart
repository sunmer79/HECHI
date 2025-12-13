import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HECHI",
        style: GoogleFonts.sedgwickAveDisplay(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF4DB56C),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}