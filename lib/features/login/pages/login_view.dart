import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

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
                      style: GoogleFonts.sedgwickAveDisplay(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4DB56C),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),


                  _buildLabel('이메일(아이디)'),
                  const SizedBox(height: 8),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            decoration: const InputDecoration(
                              hintText: "이메일을 입력해주세요",
                              hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => controller.emailError.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 10),
                    child: Text(controller.emailError.value, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  )
                      : const SizedBox()),

                  const SizedBox(height: 20),


                  _buildLabel('비밀번호'),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            decoration: const InputDecoration(
                              hintText: "비밀번호를 입력해주세요",
                              hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        // 아이콘
                        GestureDetector(
                          onTap: controller.togglePasswordVisibility,
                          child: Icon(
                            controller.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: const Color(0xFF717171),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Obx(() => controller.passwordError.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 10),
                    child: Text(controller.passwordError.value, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  )
                      : const SizedBox()),

                  const SizedBox(height: 12),


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


                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => controller.login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB56C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: Obx(() => controller.isLoading.value
                          ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                          : const Text("로그인", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                    ),
                  ),

                  const SizedBox(height: 24),

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


  Widget _buildLabel(String text) {
    return Row(
      children: [
        const Text('* ', style: TextStyle(color: Color(0xFF4DB56C), fontSize: 14, fontWeight: FontWeight.bold)),
        Text(
            text,
            style: const TextStyle(
                color: Color(0xFF3F3F3F),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500
            )
        ),
      ],
    );
  }
}