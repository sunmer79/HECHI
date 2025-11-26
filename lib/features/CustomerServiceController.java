import 'package:get/get.dart';

class CustomerServiceController extends GetxController {
  var faqs = <Map<String, String>>[].obs;
  var inquiries = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    faqs.value = [
      {"question": "책 등록 방법", "answer": "홈페이지에서 '책 등록' 버튼 클릭 후 입력"},
      {"question": "책 검색 방법", "answer": "검색창에 제목 입력 후 검색"},
      {"question": "리뷰 작성 방법", "answer": "도서 상세 페이지에서 리뷰 작성"},
      {"question": "평점 남기기", "answer": "책 상세 페이지에서 별점 입력"},
      {"question": "북마크 추가 방법", "answer": "책 상세 페이지에서 북마크 버튼 클릭"},
      {"question": "위시리스트 추가", "answer": "도서 상세 페이지에서 위시 버튼 클릭"},
      {"question": "문의 답변 확인", "answer": "내 문의 내역에서 확인 가능"},
    ];

    inquiries.value = [
      {"title": "책 등록 문의", "status": "waiting"},
      {"title": "리뷰 등록 문의", "status": "answered"},
    ];
  }

  void addInquiry(String title) {
    inquiries.add({"title": title, "status": "waiting"});
  }
}
