import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_detail_controller.dart';
import '../widgets/custom_app_header.dart';
import '../widgets/book_cover_header.dart';
import '../widgets/book_info_section.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/reading_status_card.dart';
import '../widgets/custom_bottom_nav.dart';

class ReadingDetailView extends GetView<ReadingDetailController> {
  const ReadingDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: 412, // Original design width
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Status Bar & Navigation
              const CustomAppHeader(),

              // 2. Book Cover Image & Gradient
              BookCoverHeader(),

              // 3. Book Title & Info
              BookInfoSection(),

              const SizedBox(height: 20),

              // 4. Action Buttons (Bookmark, Highlight, Memo)
              const ActionButtonsRow(),

              const SizedBox(height: 20),

              // 5. Reading Status Card
              ReadingStatusCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}