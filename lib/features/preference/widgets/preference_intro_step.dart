import 'package:flutter/material.dart';

class PreferenceIntroStep extends StatelessWidget {
  const PreferenceIntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF4DB56C),
      child: const Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '독서 ', style: TextStyle(color: Color(0xFFD1ECD9), fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
              TextSpan(text: '취향', style: TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.w900)),
              TextSpan(text: '\n알아보기', style: TextStyle(color: Color(0xFFD1ECD9), fontSize: 28, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}