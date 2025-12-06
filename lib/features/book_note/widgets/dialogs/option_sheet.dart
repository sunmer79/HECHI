import 'package:flutter/material.dart';

void showOptionSheet({
  required BuildContext context,
  required String title,
  required VoidCallback onDelete,
  required VoidCallback onMemo,
  required bool isMemo, // true면 "메모 수정", false면 "메모 작성"
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// HEADER
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "취소",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4DB56C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),

        /// DELETE
        _optionItem(label: "삭제", color: Colors.red, callback: onDelete),

        /// MEMO WRITE or MEMO EDIT
        _optionItem(
          label: isMemo ? "메모 수정" : "메모 작성",
          color: Colors.black,
          callback: onMemo,
        ),
      ],
    ),
  );
}

Widget _optionItem({
  required String label,
  required Color color,
  required VoidCallback callback,
}) {
  return InkWell(
    onTap: callback,
    child: Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 17, color: color)),
    ),
  );
}
