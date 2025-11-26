import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_service_controller.dart';
import '../widgets/faq_tile.dart';
import '../widgets/inquiry_tile.dart';

class CustomerServicePage extends StatelessWidget {
  CustomerServicePage({Key? key}) : super(key: key);

  final controller = Get.put(CustomerServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        switch (controller.currentViewIndex.value) {
          case 0: return _buildMainView();     // 메인
          case 1: return _buildHistoryView();  // 문의 내역 리스트
          case 2: return _buildRegisterView(); // 문의 등록
          case 3: return _buildDetailView();   // 문의 상세 (수정됨)
          case 4: return _buildFaqDetailView();// FAQ 상세
          default: return _buildMainView();
        }
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          if (controller.currentViewIndex.value == 3 || controller.currentViewIndex.value == 4) {
            if (controller.currentViewIndex.value == 4) {
              controller.changeView(0);
            } else {
              controller.changeView(1); // 문의상세(3)는 내역목록(1)으로
            }
          } else if (controller.currentViewIndex.value != 0) {
            controller.changeView(0); // 리스트/등록 -> 메인으로 복귀
          } else {
            Get.back(); // 앱 종료 or 이전 화면
          }
        },
      ),
      title: Obx(() {
        String title = '고객센터';
        if (controller.currentViewIndex.value == 1) title = '문의내역';
        if (controller.currentViewIndex.value == 2) title = '문의등록';
        if (controller.currentViewIndex.value == 3) title = '문의내역'; // 상세 페이지 타이틀
        if (controller.currentViewIndex.value == 4) title = '자주 묻는 질문';
        return Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        );
      }),
    );
  }

  // --- FAQ 상세 화면 ---
  Widget _buildFaqDetailView() {
    final faq = controller.selectedFaq;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Q.", style: TextStyle(color: Color(0xFF4DB56C), fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  faq['title'] ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 300),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("A.", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Text(
                  faq['content'] ?? '',
                  style: const TextStyle(color: Color(0xFF555555), fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- [수정됨] 문의 상세 화면 ---
  // 사용자님이 요청하신 Cshistorydetailpage 디자인 반영
  Widget _buildDetailView() {
    final inquiry = controller.selectedInquiry;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 상단 여백 등은 필요에 따라 추가
          const SizedBox(height: 20),

          // 1. 제목 섹션
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // [수정] 왼쪽 정렬 추가
              children: [
                const Text(
                  '제목',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  // height: 57, // 텍스트 길이에 따라 유동적으로 늘어나도록 높이 제한 해제
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFABABAB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    inquiry['title'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF717171),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. 설명 섹션
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // [수정] 왼쪽 정렬 추가
              children: [
                const Text(
                  '설명',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 247), // 최소 높이 설정
                  padding: const EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFABABAB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    inquiry['content'] ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 날짜 및 상태 표시 (추가 정보)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('작성일: ${inquiry['date']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(width: 10),
                Text(
                  inquiry['status'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: inquiry['status'] == '답변완료' ? const Color(0xFF4DB56C) : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 기존 뷰들 ---

  Widget _buildMainView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton('문의내역', false, () => controller.changeView(1)),
                const SizedBox(width: 10),
                _buildActionButton('문의등록', true, () => controller.changeView(2)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: const [Icon(Icons.search, color: Color(0xFFABABAB)), SizedBox(width: 10), Text('검색', style: TextStyle(color: Color(0xFFABABAB)))]),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4DB56C), width: 2), borderRadius: BorderRadius.circular(20)),
              child: const Text('FAQ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
            children: controller.faqList.map((faq) => FaqTile(
              title: faq['title']!,
              onTap: () => controller.viewFaqDetail(faq),
            )).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.myInquiries.length,
      itemBuilder: (context, index) {
        final item = controller.myInquiries[index];
        return InquiryTile(
          title: item['title']!,
          status: item['status']!,
          date: item['date']!,
          onTap: () => controller.viewDetail(item),
        );
      },
    ));
  }

  Widget _buildRegisterView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('제목'),
          const SizedBox(height: 10),
          TextField(controller: controller.titleController, decoration: _inputDeco('제목을 입력하세요')),
          const SizedBox(height: 20),
          _buildInputLabel('설명'),
          const SizedBox(height: 10),
          TextField(controller: controller.contentController, maxLines: 8, decoration: _inputDeco('문의 내용을 자세히 적어주세요')),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.submitInquiry,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DB56C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: const Text('제출', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  Widget _buildInputLabel(String text) => Text(text, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500));

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFABABAB))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFABABAB))),
  );

  Widget _buildActionButton(String text, bool isFilled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isFilled ? const Color(0xFF4DB56C) : Colors.white,
          border: Border.all(color: const Color(0xFF4DB56C)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(text, style: TextStyle(color: isFilled ? Colors.white : const Color(0xFF4DB56C), fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }
}