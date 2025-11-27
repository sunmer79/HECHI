import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final Widget? suffix;
  final bool readOnly;
  final bool showAsterisk; // 기본값 true (항상 보임)

  const SignUpTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.suffix,
    this.readOnly = false,
    this.showAsterisk = true, // ✅ 기본적으로 별표가 보이도록 설정
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 영역
        Row(
          children: [
            // showAsterisk가 true면 무조건 표시 (기본값)
            if (showAsterisk)
              const Text(
                '* ',
                style: TextStyle(
                  color: Color(0xFF4DB56C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF3F3F3F),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 입력창 영역
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscure,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
      ],
    );
  }
}