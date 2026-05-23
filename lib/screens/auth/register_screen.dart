// lib/modules/auth/register/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/auth_controller.dart';
import 'package:taskflow/widgets/app_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        size: 16, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.primaryShadow,
                          ),
                          child: const Center(
                            child: Icon(Icons.bolt_rounded,
                                color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
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
                        'Buat Akun ✨',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Daftar dan mulai produktif',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Nama Lengkap',
                        hint: 'John Doe',
                        controller: controller.nameController,
                        prefixIcon: const Icon(Icons.person_outline,
                            size: 18, color: AppColors.textHint),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      Obx(() => AppTextField(
                            label: 'Konfirmasi Password',
                            hint: '••••••••',
                            controller: controller.confirmPasswordController,
                            obscureText:
                                !controller.isConfirmPasswordVisible.value,
                            prefixIcon: const Icon(Icons.lock_outline,
                                size: 18, color: AppColors.textHint),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                                color: AppColors.textHint,
                              ),
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                          )),
                      const SizedBox(height: 20),
                      Obx(
                        () => controller.errorMessage.value.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.error.withOpacity(0.2)),
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
                      GradientButton(
                        text: 'Create Account',
                        isLoading: controller.isLoading.value,
                        onTap: controller.register,
                        icon: const Icon(
                          Icons.rocket_launch_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sudah punya akun?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Sign In',
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
    );
  }
}
