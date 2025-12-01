import 'package:flutter/material.dart'; // ✅ Alignment 때문에 필수!
import 'package:get/get.dart';

class TasteAnalysisController extends GetxController {
  // 1. 평가 수
  final countStats = {'소설': 8, '시': 5, '에세이': 11, '만화': 6};

  // 2. 별점 분포 (색상 포함)
  final starRatingDistribution = [
    {'score': 5, 'ratio': 0.8, 'color': 0xFF43A047},
    {'score': 4, 'ratio': 0.6, 'color': 0xFF66BB6A},
    {'score': 3, 'ratio': 0.4, 'color': 0xFF81C784},
    {'score': 2, 'ratio': 0.3, 'color': 0xFFA5D6A7},
    {'score': 1, 'ratio': 0.15, 'color': 0xFFC8E6C9},
  ];

  // 요약 정보
  final String averageRating = "4.5";
  final String totalReviews = "28";
  final String readingRate = "88%";
  final String mostGivenRating = "4.0";
  final String totalReadingTime = "52";

  // 3. 선호 태그
  final tags = [
    {'text': '힐링', 'size': 32.0, 'color': 0xFF4DB56C, 'align': Alignment.center},
    {'text': '스릴 넘친', 'size': 26.0, 'color': 0xFF4DB56C, 'align': const Alignment(0.5, 0.5)},
    {'text': '절망', 'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.6, -0.5)},
    {'text': '블랙 코미디', 'size': 16.0, 'color': 0xFFAAD1B6, 'align': const Alignment(-0.8, 0.2)},
    {'text': '감동적인', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(-0.3, 0.6)},
    {'text': '깊이 있는', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.8, 0.8)},
    {'text': '소설', 'size': 14.0, 'color': 0xFF89C99C, 'align': const Alignment(0.7, -0.6)},
  ];

  // 4. 선호 장르
  final genreRankings = [
    {'genre': '코미디', 'score': 93, 'count': 5},
    {'genre': '가족', 'score': 96, 'count': 4},
    {'genre': '미스터리', 'score': 91, 'count': 3},
    {'genre': '추리', 'score': 92, 'count': 2},
    {'genre': '스릴러', 'score': 87, 'count': 2},
    {'genre': '공포', 'score': 88, 'count': 2},
    {'genre': 'SF', 'score': 89, 'count': 2},
    {'genre': '판타지', 'score': 92, 'count': 2},
    {'genre': '로맨스', 'score': 87, 'count': 2},
    {'genre': '무협', 'score': 86, 'count': 2},
    {'genre': '역사', 'score': 81, 'count': 2},
    {'genre': '과학', 'score': 97, 'count': 1},
    {'genre': '철학', 'score': 95, 'count': 1},
  ];
}