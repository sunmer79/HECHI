import 'package:flutter/material.dart';
import '../widgets/notification_tile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 30),
        children: const [
          NotificationTile(
            imageUrl: "https://picsum.photos/80/120",
            title: "“기억을 잃었는데 지구를 구하라고요?”",
            description: "26년 상반기 영화 개봉! <마션> 앤디 위어의 경이로운 우주 활극 [프로젝트 헤일메리] 추천 소설",
            date: "2024.11.25",
          ),
          NotificationTile(
            imageUrl: "https://picsum.photos/80/121",
            title: "노르딕 누아르의 전설! 요 네스뵈 [블러드문]",
            description: "3년 만에 돌아온 <형사 해리 홀레> 시리즈 #13 모든 것을 잃고 산산이 부서졌던 해리의 귀환!",
            date: "2024.11.24",
          ),
          NotificationTile(
            imageUrl: "https://picsum.photos/80/122",
            title: "독서 뱃지 달성!",
            description: "축하합니다! 이번 달 독서 목표를 달성하여 '책벌레' 뱃지를 획득하셨습니다.",
            isSystem: true, // 시스템 알림 강조
            date: "2024.11.20",
          ),
          NotificationTile(
            imageUrl: "https://picsum.photos/80/123",
            title: "그룹, 팔로우 등...",
            description: "회원님의 친구가 새로운 게시물을 올렸습니다. 지금 확인해보세요!",
            date: "2024.11.18",
          ),
        ],
      ),
    );
  }
}