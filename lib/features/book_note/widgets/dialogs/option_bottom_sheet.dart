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

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              label: "삭제",
              color: Colors.red,
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

            const Divider(height: 1, thickness: .3),

            _buildOption(
              label: hasMemo || type == "memo" ? "메모 수정" : "메모 작성",
              onTap: () {
                Get.back();
                _openEditor();
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
    return ListTile(
      title: Text(label, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
    );
  }

  Widget _buildCancel() {
    return ListTile(
      title: const Center(
        child: Text("취소", style: TextStyle(fontSize: 16, color: Colors.grey)),
      ),
      onTap: () => Get.back(),
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


/*
class OptionBottomSheet extends StatelessWidget {
  final String type; // bookmark | highlight | memo
  final Map<String, dynamic> data;

  const OptionBottomSheet({
    super.key,
    required this.type,
    required this.data,
  });

  bool get hasMemoOrContent {
    if (type == "bookmark") return (data["memo"] ?? "").toString().isNotEmpty;
    if (type == "highlight") return (data["memo"] ?? "").toString().isNotEmpty;
    return (data["content"] ?? "").toString().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ---------------------------
            /// 삭제
            /// ---------------------------
            _buildOption(
              label: "삭제",
              color: Colors.red,
              onTap: () {
                Get.back();

                if (type == "bookmark") controller.deleteBookmark(data["id"]);
                else if (type == "highlight") controller.deleteHighlight(data["id"]);
                else controller.deleteMemo(data["id"]);
              },
            ),

            const Divider(height: 1),

            /// ---------------------------
            /// 수정 또는 작성
            /// ---------------------------
            _buildOption(
              label: hasMemoOrContent ? "수정" : "작성",
              onTap: () {
                Get.back();

                Get.bottomSheet(
                  CreationOverlay(
                    type: type,
                    isEdit: hasMemoOrContent,
                    itemId: data["id"],

                    /// 북마크
                    page: data["page"],
                    memo: data["memo"],

                    /// 하이라이트
                    sentence: data["sentence"],
                    isPublic: data["is_public"],

                    /// 메모
                    content: data["content"],
                  ),
                  isScrollControlled: true,
                );
              },
            ),

            const SizedBox(height: 8),
            _cancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String label,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(label, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
    );
  }

  Widget _cancelButton() {
    return ListTile(
      title: const Center(
        child: Text("취소", style: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
      onTap: () => Get.back(),
    );
  }
}
*/
