import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../book_storage/pages/book_storage_view.dart';
import '../../book_storage/bindings/book_storage_binding.dart';

class ArchiveLinkButton extends StatelessWidget {
  const ArchiveLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const BookStorageView(), binding: BookStorageBinding()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("보관함으로 이동하기", style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}