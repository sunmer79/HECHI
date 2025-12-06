import 'package:flutter/material.dart';

void showSortBottomSheet(
    BuildContext context,
    String currentSort,
    Function(String) onSelect,
    ) {
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
              const Center(
                child: Text(
                  "정렬",
                  style: TextStyle(
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

        _sortItem("날짜 순", currentSort == "date", () {
          Navigator.pop(context);
          onSelect("date");
        }),

        _sortItem("페이지 순", currentSort == "page", () {
          Navigator.pop(context);
          onSelect("page");
        }),
      ],
    ),
  );
}

Widget _sortItem(String title, bool selected, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          if (selected)
            const Icon(Icons.check, size: 20, color: Color(0xFF4DB56C)),
        ],
      ),
    ),
  );
}
