import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/taste_analysis_controller.dart';

class PreferredTagCloud extends GetView<TasteAnalysisController> {
  const PreferredTagCloud({super.key});

  // ✅ [시연용 더미 데이터]
  // API 데이터가 없을 때 보여줄 '감성적인 문구' 태그들입니다.
  final List<Map<String, dynamic>> _dummyTags = const [
    // 중심부 (크고 진한 색)
    {'text': '로맨틱한', 'size': 18.0, 'color': 0xFF4DB56C, 'position': Offset(0.35, 0.35)},
    {'text': '인상 깊은', 'size': 17.0, 'color': 0xFF4DB56C, 'position': Offset(0.6, 0.45)},
    {'text': '스릴 있는', 'size': 16.0, 'color': 0xFF4DB56C, 'position': Offset(0.2, 0.55)},

    // 주변부 (작고 연한 색)
    {'text': '따뜻한', 'size': 13.0, 'color': 0xFF8FBC8F, 'position': Offset(0.05, 0.25)},
    {'text': '여운이 남는', 'size': 12.0, 'color': 0xFF8FBC8F, 'position': Offset(0.75, 0.20)},
    {'text': '몰입감 넘치는', 'size': 13.0, 'color': 0xFF8FBC8F, 'position': Offset(0.5, 0.1)},
    {'text': '철학적인', 'size': 12.0, 'color': 0xFF8FBC8F, 'position': Offset(0.1, 0.75)},
    {'text': '눈물나는', 'size': 11.0, 'color': 0xFF8FBC8F, 'position': Offset(0.65, 0.75)},
    {'text': '반전 있는', 'size': 12.0, 'color': 0xFF8FBC8F, 'position': Offset(0.4, 0.85)},
    {'text': '유쾌한', 'size': 11.0, 'color': 0xFF8FBC8F, 'position': Offset(0.85, 0.55)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "독서 선호 태그",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F3F3F)
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            // ✅ 실제 데이터가 있으면 그것을 쓰고, 없으면 위에서 만든 '_dummyTags'를 사용합니다.
            // (시연을 위해 totalReviews 체크를 잠시 무시하고 더미를 우선 보여줄 수도 있습니다)
            final displayTags = controller.tags.isNotEmpty
                ? controller.tags
                : _dummyTags;

            const double stackHeight = 180; // 태그들이 겹치지 않게 높이를 조금 여유 있게 줌

            return SizedBox(
              height: stackHeight,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: displayTags.map((tag) {
                      double size = (tag['size'] as num).toDouble();
                      Color color = Color(tag['color'] as int);
                      Offset position = tag['position'] as Offset;

                      // 글자 크기를 살짝 키워 가독성을 높임
                      final fontSize = size * 1.2;

                      return Positioned(
                        // 화면 너비/높이 내에서 비율(0.0~1.0)에 맞춰 배치
                        // * 0.85는 너무 끝으로 가지 않게 안쪽으로 모아주는 역할
                        left: position.dx * constraints.maxWidth * 0.85,
                        top: position.dy * stackHeight * 0.85,
                        child: Text(
                          tag['text'] as String,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: color,
                            fontWeight: FontWeight.w600,
                            // 흰색 그림자를 넣어 글씨가 더 또렷하게 보이게 함
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.white.withOpacity(0.8),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}