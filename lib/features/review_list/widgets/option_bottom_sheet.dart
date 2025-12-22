import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionBottomSheet extends StatelessWidget {
  final int reviewId;
  final void Function(int reviewId)? onEdit;
  final void Function(int reviewId)? onDelete;

  const OptionBottomSheet({
    super.key,
    required this.reviewId,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              label: "수정",
              onTap: () {
                Get.back();
                onEdit?.call(reviewId);
              },
            ),

            _buildOption(
              label: "삭제",
              color: Colors.red.withValues(alpha: 0.5),
              onTap: () {
                Get.back();
                _showDeleteDialog();
              },
            ),

            const SizedBox(height: 6),
            _buildCancel(),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // 공통 옵션 버튼
  // =====================================================
  Widget _buildOption({
    required String label,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFFABABAB)),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
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

  // =====================================================
  // 삭제 확인 다이얼로그
  // =====================================================
  void _showDeleteDialog() {
    Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 200,
            height: 107,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      '코멘트를 삭제하시겠습니까',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                Container( height: 1, color: const Color(0xFFF3F3F3),),

                SizedBox(
                  height: 36,
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            onTap: () {
                              Get.back();
                              if (onDelete != null) {
                                onDelete!(reviewId);
                              } else {
                                print("❌ onDelete 함수가 연결되지 않았습니다!");
                              }
                            },
                            child: const Center(
                              child: Text(
                                '네',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF4DB56C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(width: 1, color: const Color(0xFFF3F3F3),),

                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            onTap: () => Get.back(),
                            child: const Center(
                              child: Text(
                                '아니오',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF4DB56C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}