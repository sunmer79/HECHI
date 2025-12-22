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

    var sortedData = List<Map<String, dynamic>>.from(ratingData);
    sortedData.sort((a, b) => (a['score'] as num).compareTo(b['score'] as num));

    double maxRatio = 0.0;
    for (var d in sortedData) {
      double r = (d['ratio'] as num).toDouble();
      if (r > maxRatio) maxRatio = r;
    }

    double mostFrequentScore = double.tryParse(mostGivenRating) ?? 0.0;
    const Color figmaDarkGreen = Color(0xFF4EB56D);
    const Color figmaLightGreen = Color(0xFFC8E6C9);

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

                Color barColor = (score == mostFrequentScore) ? figmaDarkGreen : figmaLightGreen;
                if (ratio == 0) barColor = const Color(0xFFF5F5F5);

                const double maxHeight = 60.0;
                double barHeight = 2.0;

                if (maxRatio > 0 && ratio > 0) {
                  barHeight = (ratio / maxRatio) * maxHeight;
                }

                bool isMostFrequentBar = (ratio == maxRatio && ratio > 0);
                bool isFirst = idx == 0;
                bool isLast = idx == sortedData.length - 1;
                bool showLabel = isMostFrequentBar || isFirst || isLast;

                String scoreText = score % 1 == 0 ? score.toInt().toString() : score.toStringAsFixed(1);

                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (showLabel) ...[
                          Text(
                            scoreText,
                            style: const TextStyle(
                              fontSize: 12, // 라벨 크기 조정
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ] else
                          const SizedBox(height: 20), // 텍스트 공간 확보

                        SizedBox(
                          width: 24, // 막대 너비 조정
                          height: barHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
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