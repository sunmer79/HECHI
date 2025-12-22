import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';
import '../widgets/book_cover_header.dart'; // 수정된 헤더 사용
import '../widgets/book_info_section.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/reading_status_card.dart';
import '../../../core/widgets/bottom_bar.dart';

class ReadingDetailView extends StatefulWidget {
  const ReadingDetailView({Key? key}) : super(key: key);

  @override
  State<ReadingDetailView> createState() => _ReadingDetailViewState();
}

class _ReadingDetailViewState extends State<ReadingDetailView> {
  final scrollController = ScrollController();
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 스크롤 리스너 추가: 200px 지점부터 100px 동안 opacity를 0에서 1로 변경
    scrollController.addListener(() {
      double offset = scrollController.offset;
      double newOpacity = ((offset - 200) / 100).clamp(0.0, 1.0);
      setState(() => opacity = newOpacity);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReadingDetailController>();

    return Scaffold(
      extendBodyBehindAppBar: true, // 본문이 AppBar 영역까지 올라오도록 설정
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(opacity),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Opacity(
          opacity: opacity,
          child: Obx(() => Text(
            controller.bookTitle.value, // 컨트롤러의 제목 변수명에 맞춰 수정 필요
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            // 배경이 흰색으로 변하면 아이콘은 검은색, 투명할 때는 흰색
            color: opacity > 0.5 ? Colors.black : Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          controller: scrollController, // 컨트롤러 연결
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookCoverHeader(), // 아래에서 수정한 위젯
              const BookInfoSection(),
              const SizedBox(height: 20),
              const ActionButtonsRow(),
              const SizedBox(height: 20),
              ReadingStatusCard(),
              // 하단 여백 추가 (필요시)
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
      bottomNavigationBar: const BottomBar(),
    );
  }
}