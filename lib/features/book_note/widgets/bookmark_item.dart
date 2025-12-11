import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/dialogs/option_bottom_sheet.dart';
import '../widgets/styles/item_common.dart';

class BookmarkItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const BookmarkItem({super.key, required this.data});

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
          "페이지 ${data["page"]}",
          style: ItemCommon.titleStyle,
        ),

        if (hasMemo) ...[
          const SizedBox(height: 6),
          Text(memo, style: ItemCommon.memoStyle),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDate(data["created_date"]),
          style: ItemCommon.subStyle,
        ),

        GestureDetector(
          onTap: () => Get.bottomSheet(
            OptionBottomSheet(
              type: "bookmark",
              data: data,
            ),
          ),
          child: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        ),
      ],
    );
  }

  /// 날짜 포맷
  String _formatDate(String raw) {
    final date = DateTime.parse(raw);
    return "${date.year}.${date.month}.${date.day}";
  }
}
