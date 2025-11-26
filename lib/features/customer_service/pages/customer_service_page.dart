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
          case 0:
            return _buildMainView();
          case 1:
            return _buildHistoryView();
          case 2:
            return _buildRegisterView();
          default:
            return _buildMainView();
        }
      }),
    );
  }

  // 상단 앱바 (공통)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // 뒤로가기 로직: 메인이 아니면 메인으로, 메인이면 앱 종료 등
          if (controller.currentViewIndex.value != 0) {
            controller.changeView(0);
          } else {
            // Get.back(); // 네비게이션 스택이 있다면
          }
        },
      ),
      centerTitle: true,
      title: Obx(() {
        String title = '고객센터';
        if (controller.currentViewIndex.value == 1) title = '문의내역';
        if (controller.currentViewIndex.value == 2) title = '문의등록';
        return Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        );
      }),
    );
  }

  // 1. 메인 뷰 (FAQ 및 메뉴 버튼)
  Widget _buildMainView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // 상단 버튼 영역 (문의내역 / 문의등록)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  text: '문의내역',
                  isFilled: false,
                  onTap: () => controller.changeView(1),
                ),
                const SizedBox(width: 10),
                _buildActionButton(
                  text: '문의등록',
                  isFilled: true,
                  onTap: () => controller.changeView(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // 검색창
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Color(0xFFABABAB)),
                SizedBox(width: 10),
                Text('검색', style: TextStyle(color: Color(0xFFABABAB))),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // FAQ 섹션 타이틀
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4DB56C), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'FAQ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // FAQ 리스트
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.faqList.length,
            itemBuilder: (context, index) {
              return FaqTile(title: controller.faqList[index]);
            },
          )),
          const SizedBox(height: 50),
          // 로고 (HECHI)
          const Text(
            'HECHI',
            style: TextStyle(
              color: Color(0xFF4DB56C),
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // 2. 문의 내역 뷰
  Widget _buildHistoryView() {
    return Obx(() => controller.myInquiries.isEmpty
        ? const Center(child: Text("문의 내역이 없습니다."))
        : ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: controller.myInquiries.length,
      itemBuilder: (context, index) {
        final item = controller.myInquiries[index];
        return InquiryTile(
          title: item['title']!,
          status: item['status']!,
          date: item['date']!,
        );
      },
    ));
  }

  // 3. 문의 등록 뷰
  Widget _buildRegisterView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('제목'),
          const SizedBox(height: 10),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              hintText: '제목을 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFABABAB)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInputLabel('설명'),
          const SizedBox(height: 10),
          TextField(
            controller: controller.contentController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: '문의 내용을 자세히 적어주세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFABABAB)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInputLabel('첨부 파일'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFABABAB)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '+ 파일 추가',
                style: TextStyle(
                  color: const Color(0xFF4DB56C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.submitInquiry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DB56C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('제출',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // 헬퍼 위젯: 입력 라벨
  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // 헬퍼 위젯: 상단 액션 버튼 (문의내역/문의등록)
  Widget _buildActionButton({
    required String text,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isFilled ? const Color(0xFF4DB56C) : Colors.white,
          border: Border.all(color: const Color(0xFF4DB56C)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isFilled ? Colors.white : const Color(0xFF4DB56C),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}