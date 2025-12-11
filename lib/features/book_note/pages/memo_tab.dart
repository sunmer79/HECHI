import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_note_controller.dart';
import '../widgets/memo_item.dart';
import '../widgets/dialogs/sort_bottom_sheet.dart';
import '../widgets/overlays/creation_overlay.dart';
// import '../widgets/overlays/memo_creation_overlay.dart';

class MemoTab extends GetView<BookNoteController> {
  const MemoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookNoteController>();

    return Column(
      children: [
        _buildControlBar(context),

        Expanded(
          child: Obx(() {
            if (controller.isLoadingNotes.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.notes.isEmpty) {
              return const Center(
                child: Text("작성된 메모가 없습니다.", style: TextStyle(color: Colors.grey)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: controller.notes.length,
              itemBuilder: (context, index) {
                final item = controller.notes[index];
                return MemoItem(data: item);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 0),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildControlBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Text("메모", style: TextStyle(color: Colors.grey, fontSize: 14)),
          GestureDetector(
            onTap: () {
              /*
              Get.bottomSheet(
                MemoCreationOverlay(isEdit: false),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
               */
              Get.bottomSheet(
                CreationOverlay(
                  type: "memo",
                  isEdit: false,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          child: const Icon(Icons.edit, color: Colors.grey, size: 24),
          ),
        ],
      ),
    );
  }
}
