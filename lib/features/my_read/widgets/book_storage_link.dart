import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hechi/app/routes.dart';

class BookStorageLink extends StatelessWidget {
  const BookStorageLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 제목 왼쪽 정렬
        children: [
          // 1. 제목: 보관함
          const Text(
            "보관함",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F3F3F)
            ),
          ),

          const SizedBox(height: 10), // 제목과 버튼 사이 간격 (사진처럼 넓게)
          const Divider(color: Color(0xFFF5F5F5),  height: 1),
          const SizedBox(height: 25),
          // 2. 버튼: 보관함으로 이동하기 > (중앙 정렬)
          Center(
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.bookStorage);
              },
              borderRadius: BorderRadius.circular(8), // 클릭 시 물결 효과 둥글게
              child: const Padding(
                padding: EdgeInsets.all(10.0), // 터치 영역 확보
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 내용물 크기만큼만 차지
                  children: [
                    Text(
                      "보관함으로 이동하기",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                          fontWeight: FontWeight.w500 // 연한 회색
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF9E9E9E),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}