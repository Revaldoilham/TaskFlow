// lib/modules/auth/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/auth_controller.dart';
import 'package:taskflow/widgets/app_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Logo & Branding
                  Center(
                    child: Column(
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.primaryShadow,
                            ),
                            child: const Center(
                              child: Icon(Icons.bolt_rounded,
                                  color: Colors.white, size: 42),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppConstants.appName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppConstants.appSlogan,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppColors.elevatedShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang 👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Masuk untuk melanjutkan aplikasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          label: 'Email',
                          hint: 'you@example.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined,
                              size: 18, color: AppColors.textHint),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => AppTextField(
                              label: 'Password',
                              hint: '••••••••',
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              prefixIcon: const Icon(Icons.lock_outline,
                                  size: 18, color: AppColors.textHint),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: AppColors.textHint,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            )),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Obx(() => GestureDetector(
                                  onTap: controller.toggleRememberMe,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: controller.rememberMe.value
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: controller.rememberMe.value
                                                ? AppColors.primary
                                                : const Color(0xFFCBD5E1),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: controller.rememberMe.value
                                            ? const Icon(Icons.check,
                                                size: 12, color: Colors.white)
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remember me',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const Spacer(),
                            Text(
                              'Lupa Password?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Error message
                        Obx(
                          () => controller.errorMessage.value.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            AppColors.error.withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: AppColors.error, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          controller.errorMessage.value,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        GetX<AuthController>(
                          builder: (controller) {
                            return GradientButton(
                              text: 'Sign In',
                              isLoading: controller.isLoading.value,
                              onTap: controller.login,
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quick login hint
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Text(
                        'Demo: email bebas & password minimal 6 karakter',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                         'Belum punya akun?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppConstants.registerRoute),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
