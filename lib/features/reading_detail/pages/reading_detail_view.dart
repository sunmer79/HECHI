import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';
import '../widgets/custom_app_header.dart';
import '../widgets/book_cover_header.dart';
import '../widgets/book_info_section.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/reading_status_card.dart';
import '../../../core/widgets/bottom_bar.dart';

class ReadingDetailView extends GetView<ReadingDetailController> {
  const ReadingDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,

        leading: Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            ),
          ],
        ),
        title: const SizedBox.shrink(),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookCoverHeader(),
                BookInfoSection(),
                const SizedBox(height: 20),
                const ActionButtonsRow(),
                const SizedBox(height: 20),
                ReadingStatusCard(),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const BottomBar(),
    );
  }
}