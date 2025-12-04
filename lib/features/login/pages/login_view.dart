import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "HECHI",
                      style: GoogleFonts.sedgwickAveDisplay( // 폰트 이름 적용
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4DB56C),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // 2️⃣ [복구] 이메일 입력창
                  const Text("이메일", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "이메일을 입력해주세요",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  Obx(() => controller.emailError.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(controller.emailError.value, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  )
                      : const SizedBox()),

                  const SizedBox(height: 20),

                  // 3️⃣ [복구] 비밀번호 입력창
                  const Text("비밀번호", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: "비밀번호를 입력해주세요",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
                  Obx(() => controller.passwordError.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(controller.passwordError.value, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  )
                      : const SizedBox()),

                  const SizedBox(height: 12),

                  // 4️⃣ [기능 유지] 자동 로그인 체크박스 (디자인 다듬음)
                  Row(
                    children: [
                      Obx(() => SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: controller.isAutoLogin.value,
                          onChanged: (value) => controller.toggleAutoLogin(),
                          activeColor: const Color(0xFF4DB56C),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: controller.toggleAutoLogin,
                        child: const Text("자동 로그인", style: TextStyle(color: Colors.black87, fontSize: 14)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 5️⃣ [복구] 로그인 버튼
                  ElevatedButton(
                    onPressed: () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB56C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Obx(() => controller.isLoading.value
                        ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                        : const Text("로그인", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),

                  const SizedBox(height: 24),

                  // 6️⃣ [복구] 회원가입 / 비밀번호 찾기 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: controller.goToSignUp,
                        child: const Text("회원가입", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        width: 1,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      GestureDetector(
                        onTap: controller.goToForgetPassword,
                        child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}