import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cs_model.dart';
import '../services/cs_provider.dart';

class CustomerServiceController extends GetxController {
  final CsProvider _provider = Get.put(CsProvider());

  var currentViewIndex = 0.obs;
  var isLoading = false.obs;

  var faqList = <FaqModel>[].obs;
  var myInquiries = <TicketModel>[].obs;

  var selectedInquiry = Rxn<TicketModel>();
  var selectedFaq = Rxn<FaqModel>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchFaqs(),
        fetchMyTickets(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFaqs() async {
    final response = await _provider.getFaqs();
    if (!response.status.hasError) {
      List<dynamic> data = response.body;
      faqList.value = data.map((json) => FaqModel.fromJson(json)).toList();
    }
  }

  Future<void> fetchMyTickets() async {
    final response = await _provider.getMyTickets();

    if (!response.status.hasError) {
      List<dynamic> data = response.body;
      var list = data.map((json) => TicketModel.fromJson(json)).toList();
      list.sort((a, b) => b.id.compareTo(a.id));
      myInquiries.value = list;
    }
  }

  void changeView(int index) {
    if (index == 1) fetchMyTickets();
    currentViewIndex.value = index;
  }

  void viewDetail(TicketModel inquiry) {
    selectedInquiry.value = inquiry;
    changeView(3);
  }

  void viewFaqDetail(FaqModel faq) {
    selectedFaq.value = faq;
    changeView(4);
  }

  Future<void> submitInquiry() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      Get.snackbar('알림', '제목과 내용을 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final response = await _provider.createTicket(
      titleController.text,
      contentController.text,
    );

    isLoading.value = false;

    if (response.status.hasError) {
      Get.snackbar('등록 실패', '코드: ${response.statusCode} / 메시지: ${response.statusText}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } else {
      Get.snackbar('성공', '문의가 등록되었습니다.',
          backgroundColor: const Color(0xFF4DB56C), colorText: Colors.white);

      titleController.clear();
      contentController.clear();

      await fetchMyTickets();
      changeView(1);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}