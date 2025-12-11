import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_bottom_sheet.dart';
import '../widgets/styles/item_common.dart';

class HighlightItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const HighlightItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final memo = data["memo"] ?? "";
    final hasMemo = memo.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),

        const SizedBox(height: 8),

        Text(
          data["sentence"] ?? "",
          style: ItemCommon.titleStyle,
        ),

        if (hasMemo) ...[
          const SizedBox(height: 6),
          Text(memo, style: ItemCommon.memoStyle),
        ],

        const SizedBox(height: 12),
        _buildPublicFlag(),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPublicFlag() {
    final isPublic = data["is_public"] ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPublic ? Colors.green[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isPublic ? "공개" : "비공개",
        style: TextStyle(
          color: isPublic ? Colors.green[700] : Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
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
              type: "highlight",
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
