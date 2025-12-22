import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_note_controller.dart';
import '../overlays/creation_overlay.dart';

class OptionBottomSheet extends StatelessWidget {
  final String type; // bookmark | highlight | memo
  final Map<String, dynamic> data;

  const OptionBottomSheet({
    super.key,
    required this.type,
    required this.data,
  });

  bool get hasMemo {
    final memo = data["memo"];
    return memo != null && memo.toString().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();

    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              label: hasMemo || type == "memo" ? "수정" : "메모 작성",
              onTap: () {
                Get.back();
                _openEditor();
              },
            ),

            _buildOption(
              label: "삭제",
              color: Colors.red.withValues(alpha: 0.7),
              onTap: () {
                Get.back();
                if (type == "bookmark") {
                  controller.deleteBookmark(data["id"]);
                } else if (type == "highlight") {
                  controller.deleteHighlight(data["id"]);
                } else {
                  controller.deleteMemo(data["id"]);
                }
              },
            ),

            const SizedBox(height: 6),
            _buildCancel(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 공통 UI
  // -------------------------------------------------------------
  Widget _buildOption({
    required String label,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(0xFFABABAB),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildCancel() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        alignment: Alignment.center,
        child: const Text(
          "취소",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🎯 CreationOverlay 호출 (작성/수정 공통 처리)
  // -------------------------------------------------------------
  void _openEditor() {
    if (type == "bookmark") {
      Get.bottomSheet(
        CreationOverlay(
          type: "bookmark",
          isEdit: true,
          itemId: data["id"],
          page: data["page"],
          memo: hasMemo ? data["memo"] : "",
        ),
        isScrollControlled: true,
      );
      return;
    }

    if (type == "highlight") {
      Get.bottomSheet(
        CreationOverlay(
          type: "highlight",
          isEdit: true,
          itemId: data["id"],
          page: data['page'],
          sentence: data["sentence"],
          memo: hasMemo ? data["memo"] : "",
          isPublic: data["is_public"] ?? false,
        ),
        isScrollControlled: true,
      );
      return;
    }

    // memo
    Get.bottomSheet(
      CreationOverlay(
        type: "memo",
        isEdit: true,
        itemId: data["id"],
        content: data["content"],
      ),
      isScrollControlled: true,
    );
  }
}
