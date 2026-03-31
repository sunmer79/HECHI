import 'package:flutter/material.dart';

class VerifyResendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VerifyResendButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        '인증 코드를 받지 못하셨나요? 재발송',
        style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),
      ),
    );
  }
}