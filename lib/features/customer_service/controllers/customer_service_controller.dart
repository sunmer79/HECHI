import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerServiceController extends GetxController {
  // 현재 활성화된 뷰 상태 (0: 메인/FAQ, 1: 문의내역, 2: 문의등록)
  var currentViewIndex = 0.obs;

  // 텍스트 필드 컨트롤러
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  // 더미 데이터: FAQ 리스트
  final faqList = <String>[
    '자주 묻는 질문 리스트업 해야됩니다 1',
    '자주 묻는 질문 리스트업 해야됩니다 2',
    '자주 묻는 질문 리스트업 해야됩니다 3',
    '자주 묻는 질문 리스트업 해야됩니다 4',
    '배송은 언제 되나요?',
  ].obs;

  // 더미 데이터: 나의 문의 내역
  final myInquiries = <Map<String, String>>[
    {'title': '문의내역1', 'status': '답변대기', 'date': '2025.11.01'},
    {'title': '로그인이 안돼요', 'status': '답변완료', 'date': '2025.10.28'},
  ].obs;

  // 뷰 전환 메서드
  void changeView(int index) {
    currentViewIndex.value = index;
  }

  // 문의 등록 메서드 (기능 시뮬레이션)
  void submitInquiry() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      myInquiries.insert(0, {
        'title': titleController.text,
        'status': '접수완료',
        'date': DateTime.now().toString().substring(0, 10),
      });

      // 입력창 초기화 및 내역 페이지로 이동
      titleController.clear();
      contentController.clear();
      Get.snackbar('성공', '문의가 등록되었습니다.',
          backgroundColor: const Color(0xFF4DB56C), colorText: Colors.white);
      changeView(1); // 내역 페이지로 이동
    } else {
      Get.snackbar('알림', '제목과 내용을 입력해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
