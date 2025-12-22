import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/book_detail_controller.dart';
import '../widgets/book_cover_Header.dart';
import '../widgets/book_info_section.dart';
import '../widgets/action_buttons.dart';
import '../widgets/author_section.dart';
import '../widgets/comment_section.dart';
import '../widgets/meta_info_section.dart';
import '../../../core/widgets/bottom_bar.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});
  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final scrollController = ScrollController();
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double offset = scrollController.offset;
      double newOpacity = ((offset - 200) / 100).clamp(0.0, 1.0);
      setState(() => opacity = newOpacity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookDetailController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(opacity),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Opacity(
          opacity: opacity,
          child: Obx(() => Text(
            controller.book["title"] ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: opacity > 0.5 ? Colors.black : Colors.white),
          onPressed: () => Get.back(),
        ),
      ),

      bottomNavigationBar: const BottomBar(),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookCoverHeader(),
              const BookInfoSection(),
              const Divider(thickness: 2, color: Color(0xFFF5F5F5)),
              _buildInteractiveRatingBar(),
              const Divider(thickness: 2, color: Color(0xFFF5F5F5)),
              ActionButtons(),
              const MetaInfoSection(),
              Container(height: 8, color: const Color(0xFFF5F5F5)),
              const AuthorSection(),
              Container(height: 8, color: const Color(0xFFF5F5F5)),
              const CommentSection(),
              Container(height: 8, color: const Color(0xFFF5F5F5)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInteractiveRatingBar() {
    final controller = Get.find<BookDetailController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17,),
      alignment: Alignment.center,
      child: Obx(() => RatingBar(
        initialRating: controller.myRating.value,
        minRating: 0.0,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Color(0xFFFFD700)),
          half: const Icon(Icons.star_half, color: Color(0xFFFFD700)),
          empty: const Icon(Icons.star, color: Color(0xFFD4D4D4)),
        ),
        glow: false,
        onRatingUpdate: (rating) {
          controller.myRating.value = rating;
          controller.submitRating(rating);
        },
      )),
    );
  }
}
