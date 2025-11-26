import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerServiceController extends GetxController {
  // 0: 메인, 1: 문의내역, 2: 문의등록, 3: 문의상세, 4: FAQ상세(New!)
  var currentViewIndex = 0.obs;

  // 선택된 문의 내역 데이터
  var selectedInquiry = <String, String>{}.obs;

  // [New] 선택된 FAQ 데이터
  var selectedFaq = <String, String>{}.obs;

  // 입력 필드 컨트롤러
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  // [Modified] FAQ 더미 데이터 (제목 + 내용 구조로 변경)
  final faqList = <Map<String, String>>[
    {
      'title': '배송은 언제 되나요?',
      'content': '배송은 주문일로부터 영업일 기준 2~3일 소요됩니다. 도서 산간 지역은 추가 소요될 수 있습니다.'
    },
    {
      'title': '교환/반품 신청은 어떻게 하나요?',
      'content': '마이페이지 > 주문내역에서 교환/반품 신청이 가능합니다. 수령 후 7일 이내에만 가능합니다.'
    },
    {
      'title': '회원 탈퇴는 어디서 하나요?',
      'content': '설정 > 계정 관리 메뉴 하단에서 회원 탈퇴 버튼을 찾으실 수 있습니다.'
    },
    {
      'title': '결제 수단을 변경하고 싶어요.',
      'content': '이미 주문이 완료된 건은 결제 수단 변경이 불가능합니다. 취소 후 재주문 부탁드립니다.'
    },
  ].obs;

  // 문의 내역 더미 데이터
  final myInquiries = <Map<String, String>>[
    {
      'title': '로그인이 안돼요',
      'status': '답변대기',
      'date': '2025.11.01',
      'content': '로그인을 하려고 하는데 비밀번호가 자꾸 틀렸다고 나옵니다. 확인 부탁드립니다.'
    },
    {
      'title': '배송 문의 드립니다.',
      'status': '답변완료',
      'date': '2025.10.28',
      'content': '주문한 상품이 언제 도착하는지 알고 싶습니다. 송장번호는 1234-5678 입니다.'
    },
  ].obs;

  // 화면 전환 메서드
  void changeView(int index) {
    currentViewIndex.value = index;
  }

  // 문의 상세 페이지 보기
  void viewDetail(Map<String, String> inquiry) {
    selectedInquiry.value = inquiry;
    changeView(3); // 3번: 문의 상세
  }

  // [New] FAQ 상세 페이지 보기
  void viewFaqDetail(Map<String, String> faq) {
    selectedFaq.value = faq;
    changeView(4); // 4번: FAQ 상세
  }

  // 문의 등록 메서드
  void submitInquiry() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      myInquiries.insert(0, {
        'title': titleController.text,
        'status': '접수완료',
        'date': DateTime.now().toString().substring(0, 10),
        'content': contentController.text,
      });

      titleController.clear();
      contentController.clear();

      Get.snackbar('성공', '문의가 등록되었습니다.',
          backgroundColor: const Color(0xFF4DB56C), colorText: Colors.white);

      changeView(1); // 등록 후 내역 화면으로 이동
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