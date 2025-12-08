import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_read_controller.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final MyReadController controller = Get.find<MyReadController>();
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.userProfile['nickname']);
    descController = TextEditingController(text: controller.description.value);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text("프로필 변경", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.camera_alt_rounded, color: Colors.white.withOpacity(0.8), size: 40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Text("이름(닉네임)", style: TextStyle(fontSize: 14, color: Color(0xFF3F3F3F))),
            const SizedBox(height: 8),
            _buildTextField(nameController, "이름(닉네임)을 입력해주세요"),

            const SizedBox(height: 24),

            const Text("소개", style: TextStyle(fontSize: 14, color: Color(0xFF3F3F3F))),
            const SizedBox(height: 8),
            _buildTextField(descController, "소개글을 입력해주세요"),

            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateProfile(nameController.text, descController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB56C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: const Text("프로필 변경하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}