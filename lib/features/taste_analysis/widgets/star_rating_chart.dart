import 'package:flutter/material.dart';

class StarRatingChart extends StatelessWidget {
  final List<Map<String, dynamic>> ratingData;
  final String mostGivenRating;

  const StarRatingChart({
    super.key,
    required this.ratingData,
    required this.mostGivenRating,
  });

  @override
  Widget build(BuildContext context) {
    if (ratingData.isEmpty) {
      return const SizedBox(
        height: 105,
        child: Center(child: Text("데이터가 부족합니다.", style: TextStyle(color: Colors.grey))),
      );
    }

    // 1. 데이터 정렬 (0.5 -> 5.0)
    var sortedData = List<Map<String, dynamic>>.from(ratingData);
    sortedData.sort((a, b) => (a['score'] as num).compareTo(b['score'] as num));

    // 2. 최대 비율 찾기 (그래프 높이용)
    double maxRatio = 0.0;
    for (var d in sortedData) {
      double r = (d['ratio'] as num).toDouble();
      if (r > maxRatio) maxRatio = r;
    }

    // 3. 최빈값 (가장 많이 준 점수) 찾기
    double mostFrequentScore = double.tryParse(mostGivenRating) ?? 0.0;

    // ✅ [피그마 색상 정의]
    const Color figmaDarkGreen = Color(0xFF4EB56D);  // 진한 초록 (강조)
    const Color figmaLightGreen = Color(0xFFC8E6C9); // 연한 초록 (기본)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),

        SizedBox(
          height: 105,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: sortedData.asMap().entries.map((entry) {
                int idx = entry.key;
                Map<String, dynamic> d = entry.value;

                double ratio = (d['ratio'] as num).toDouble();
                double score = (d['score'] as num).toDouble();

                // ✅ [색상 로직] 위젯에서 직접 결정!
                // 현재 점수가 최빈값과 같으면 진한 색, 아니면 연한 색
                Color barColor = (score == mostFrequentScore)
                    ? figmaDarkGreen
                    : figmaLightGreen;

                // 데이터가 0이면 아주 연한 회색 (배경처럼)
                if (ratio == 0) barColor = const Color(0xFFF5F5F5);

                // 높이 계산 (최대 60.0)
                const double maxHeight = 60.0;
                double barHeight = ratio > 0 ? maxHeight * ratio : 2.0;

                // 라벨 표시 (최빈값, 0.5, 5.0)
                bool isMostFrequentBar = (ratio == maxRatio && ratio > 0);
                bool isFirst = idx == 0;
                bool isLast = idx == sortedData.length - 1;
                bool showLabel = isMostFrequentBar || isFirst || isLast;

                String scoreText = score % 1 == 0
                    ? score.toInt().toString()
                    : score.toStringAsFixed(1);

                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 라벨
                        if (showLabel) ...[
                          Text(
                            scoreText,
                            style: TextStyle(
                              fontSize: 14,
                              color: isMostFrequentBar ? figmaDarkGreen : Colors.grey.shade600,
                              fontWeight: isMostFrequentBar ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ] else
                          const SizedBox(height: 20),

                        // 막대
                        SizedBox(
                          width: 30,
                          height: barHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}