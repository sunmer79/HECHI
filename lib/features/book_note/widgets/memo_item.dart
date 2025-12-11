import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_bottom_sheet.dart';
import '../widgets/styles/item_common.dart';

class MemoItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const MemoItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final content = data["content"] ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),

        const SizedBox(height: 8),

        Text(content, style: ItemCommon.memoStyle),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final created = _formatDate(data["created_date"]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(created, style: ItemCommon.subStyle),

        GestureDetector(
          onTap: () => Get.bottomSheet(
            OptionBottomSheet(
              type: "memo",
              data: data,
            ),
          ),
          child: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(String raw) {
    final date = DateTime.parse(raw);
    return "${date.year}.${date.month}.${date.day}";
  }
}
