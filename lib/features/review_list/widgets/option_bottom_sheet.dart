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
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 30),
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Color(0xFF4DB56C), fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),

          // 수정 버튼
          _buildOption("수정", () {
            Get.back();
            if (onEdit != null) onEdit!(reviewId);
          }),

          // 삭제 버튼
          _buildOption("삭제", () {
            Get.back();
            // 다이얼로그
            Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: 300,
                    height: 107,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // 안내 텍스트 영역 (상단)
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

                        // 버튼 영역 (하단)
                        SizedBox(
                          height: 36,
                          child: Row(
                            children: [
                              // [네] 버튼
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

                              // [아니오] 버튼
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
          }),
        ],
      ),
    );
  }

  Widget _buildOption(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.50, color: Color(0xFFABABAB)),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}