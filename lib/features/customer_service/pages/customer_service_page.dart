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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4DB56C)));
        }

        switch (controller.currentViewIndex.value) {
          case 0: return _buildMainView();
          case 1: return _buildHistoryView();
          case 2: return _buildRegisterView();
          case 3: return _buildDetailView();
          case 4: return _buildFaqDetailView();
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
          if (controller.currentViewIndex.value == 3) {
            controller.changeView(1);
          } else if (controller.currentViewIndex.value == 4) {
            controller.changeView(0);
          } else if (controller.currentViewIndex.value != 0) {
            controller.changeView(0);
          } else {
            Get.back();
          }
        },
      ),
      title: Obx(() {
        String title = '고객센터';
        int index = controller.currentViewIndex.value;
        if (index == 1 || index == 3) title = '문의내역';
        if (index == 2) title = '문의등록';
        if (index == 4) title = '자주 묻는 질문';
        return Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        );
      }),
    );
  }

  Widget _buildFaqDetailView() {
    final faq = controller.selectedFaq.value;
    if (faq == null) return const SizedBox();

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
                  faq.question,
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
                  faq.answer,
                  style: const TextStyle(color: Color(0xFF555555), fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    final inquiry = controller.selectedInquiry.value;
    if (inquiry == null) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildDetailSection('제목', inquiry.title),
          _buildDetailSection('설명', inquiry.description, minHeight: 247),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('작성일: ${inquiry.formattedDate}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(width: 10),
                Text(
                  inquiry.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: inquiry.status == '답변완료' ? const Color(0xFF4DB56C) : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String label, String content, {double? minHeight}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: minHeight != null ? BoxConstraints(minHeight: minHeight) : null,
            padding: const EdgeInsets.all(15),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFABABAB)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              content,
              style: const TextStyle(color: Color(0xFF717171), fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

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
            decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(20)),
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

          controller.faqList.isEmpty
              ? const Padding(padding: EdgeInsets.all(20), child: Text("등록된 FAQ가 없습니다."))
              : Column(
            children: controller.faqList.map((faq) => FaqTile(
              title: faq.question,
              onTap: () => controller.viewFaqDetail(faq),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    if (controller.myInquiries.isEmpty) {
      return const Center(child: Text("문의 내역이 없습니다."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.myInquiries.length,
      itemBuilder: (context, index) {
        final item = controller.myInquiries[index];
        return InquiryTile(
          title: item.title,
          status: item.status,
          date: item.formattedDate,
          onTap: () => controller.viewDetail(item),
        );
      },
    );
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