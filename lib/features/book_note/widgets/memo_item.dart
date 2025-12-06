import 'package:flutter/material.dart';
import '../widgets/dialogs/option_sheet.dart';

class MemoItem extends StatefulWidget {
  final int id;
  final int page;
  final String content;
  final String date;
  final VoidCallback onDelete;
  final ValueChanged<String> onUpdate;

  const MemoItem({
    super.key,
    required this.id,
    required this.page,
    required this.content,
    required this.date,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<MemoItem> createState() => _MemoItemState();
}

class _MemoItemState extends State<MemoItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 17, right: 17),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 37,
                height: 37,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1ECD9),
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: const Color(0xFF4DB56C),
                ),
              ),
            ],
          ),
          const SizedBox(width: 21),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // p.xx + more
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'p.${widget.page}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showOptionSheet(
                          context: context,
                          title: '메모',
                          onDelete: widget.onDelete,
                          onMemo: _openEditSheet,
                          isMemo: true, // 메모 수정
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          size: 18,
                          color: Color(0xFFDADADA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 내용 (3줄 + 더보기 / 접기)
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3F3F3F),
                        height: 1.33,
                      ),
                    ),
                    secondChild: Text(
                      widget.content,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3F3F3F),
                        height: 1.33,
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),

                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? '접기' : '더보기',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4DB56C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    widget.date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF717171),
                      height: 1.54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 메모 수정 BottomSheet (B안) =====
  void _openEditSheet() {
    final controller = TextEditingController(text: widget.content);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 헤더 (취소 / 메모 수정)
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          '메모 수정',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            '완료',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4DB56C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE5E5E5)),

                // TextField
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                    child: TextField(
                      controller: controller,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: '메모 내용을 입력하세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                // 완료 버튼 탭 처리
                // (위 '완료'에서 Navigator.pop 후 실제 업데이트 호출)
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // BottomSheet 닫힌 뒤 내용 변경되었으면 콜백
      final newContent = controller.text.trim();
      if (newContent != widget.content.trim()) {
        widget.onUpdate(newContent);
      }
    });
  }
}
