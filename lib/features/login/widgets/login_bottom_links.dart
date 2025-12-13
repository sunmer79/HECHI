import 'package:flutter/material.dart';

class LoginBottomLinks extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onFindPassword;

  const LoginBottomLinks({
    super.key,
    required this.onSignUp,
    required this.onFindPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onSignUp,
          child: const Text("회원가입", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 1,
          height: 12,
          color: Colors.grey[300],
        ),
        GestureDetector(
          onTap: onFindPassword,
          child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
      ],
    );
  }
}