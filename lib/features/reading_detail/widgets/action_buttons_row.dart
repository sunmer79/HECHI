import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: Color(0xFFABABAB)),
          bottom: BorderSide(width: 1, color: Color(0xFFABABAB)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            '북마크',
            'assets/icons/icon_bookmark.png',
          ),
          _buildDivider(),
          _buildActionButton(
            '하이라이트',
            'assets/icons/icon_highlight.png',
          ),
          _buildDivider(),
          _buildActionButton(
            '메모',
            'assets/icons/icon_memo.png',
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(
      height: 60,
      child: VerticalDivider(color: Color(0xFF717171), width: 15),
    );
  }

  Widget _buildActionButton(String label, String iconPath) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 18,
              fontFamily: 'Roboto',
              letterSpacing: 0.25,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(9),
            decoration: ShapeDecoration(
              color: const Color(0x7FD1ECD9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
            ),
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(iconPath),
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF4EB56D),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}