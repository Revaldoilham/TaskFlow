// lib/modules/auth/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/user_model.dart';
import '/repositories/auth_repository.dart';
import '/constants/app_constants.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    currentUser.value = await _repo.getCurrentUser();
  }

  Future<void> login() async {
    errorMessage.value = '';
    if (!_validateLoginForm()) return;
    
    isLoading.value = true;
    try {
      final result = await _repo.login(
        emailController.text.trim(),
        passwordController.text,
      );
      currentUser.value = UserModel.fromJson(result['user']);
      Get.offAllNamed(AppConstants.dashboardRoute);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    errorMessage.value = '';
    if (!_validateRegisterForm()) return;

    isLoading.value = true;
    try {
      final result = await _repo.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );
      currentUser.value = UserModel.fromJson(result['user']);
      Get.offAllNamed(AppConstants.dashboardRoute);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    currentUser.value = null;
    Get.offAllNamed(AppConstants.loginRoute);
  }

  bool _validateLoginForm() {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    return true;
  }

  bool _validateRegisterForm() {
    if (nameController.text.isEmpty) {
      errorMessage.value = 'Please enter your name';
      return false;
    }
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return false;
    }
    return true;
  }

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void toggleRememberMe() => rememberMe.value = !rememberMe.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}