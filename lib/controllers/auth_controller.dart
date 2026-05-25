// lib/modules/auth/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../constants/app_constants.dart';

class AuthController extends GetxController {
final AuthRepository _repo = AuthRepository();

// ─── Reactive State ─────────────────────────────────────────────

final RxBool isLoading = false.obs;
final RxBool isPasswordVisible = false.obs;
final RxBool isConfirmPasswordVisible = false.obs;
final RxBool rememberMe = false.obs;

final RxString errorMessage = ''.obs;

final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

// ─── Form Controllers ──────────────────────────────────────────

final emailController = TextEditingController();
final passwordController = TextEditingController();
final nameController = TextEditingController();
final confirmPasswordController = TextEditingController();

// ─── Lifecycle ─────────────────────────────────────────────────

@override
void onInit() {
super.onInit();
_loadUser();
}

// ─── Load Current User ─────────────────────────────────────────

Future<void> _loadUser() async {
try {
currentUser.value = await _repo.getCurrentUser();
} catch (e) {
debugPrint('Load user error: $e');
}
}

// ─── Login ─────────────────────────────────────────────────────

Future<void> login() async {
errorMessage.value = '';


if (!_validateLoginForm()) return;

isLoading.value = true;

try {
  final result = await _repo.login(
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  final user = result['user'];

  if (user != null) {
    currentUser.value = UserModel.fromJson(user);
  }

  Get.offAllNamed(AppConstants.dashboardRoute);

} catch (e) {
  errorMessage.value =
      e.toString().replaceAll('Exception: ', '');

  Get.snackbar(
    'Login Gagal',
    errorMessage.value,
    snackPosition: SnackPosition.BOTTOM,
  );
} finally {
  isLoading.value = false;
}


}

// ─── Register ──────────────────────────────────────────────────

Future<void> register() async {
errorMessage.value = '';


if (!_validateRegisterForm()) return;

isLoading.value = true;

try {
  final result = await _repo.register(
    nameController.text.trim(),
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  final user = result['user'];

  if (user != null) {
    currentUser.value = UserModel.fromJson(user);
  }

  Get.offAllNamed(AppConstants.dashboardRoute);

} catch (e) {
  errorMessage.value =
      e.toString().replaceAll('Exception: ', '');

  Get.snackbar(
    'Register Gagal',
    errorMessage.value,
    snackPosition: SnackPosition.BOTTOM,
  );
} finally {
  isLoading.value = false;
}


}

// ─── Logout ────────────────────────────────────────────────────

Future<void> logout() async {
try {
await _repo.logout();


  currentUser.value = null;

  Get.offAllNamed(AppConstants.loginRoute);

} catch (e) {
  Get.snackbar(
    'Error',
    e.toString(),
    snackPosition: SnackPosition.BOTTOM,
  );
}


}

// ─── Validation ────────────────────────────────────────────────

bool _validateLoginForm() {
if (emailController.text.trim().isEmpty) {
errorMessage.value = 'Please enter your email';
return false;
}


if (!GetUtils.isEmail(emailController.text.trim())) {
  errorMessage.value = 'Invalid email format';
  return false;
}

if (passwordController.text.isEmpty) {
  errorMessage.value = 'Please enter your password';
  return false;
}

return true;


}

bool _validateRegisterForm() {
if (nameController.text.trim().isEmpty) {
errorMessage.value = 'Please enter your name';
return false;
}


if (emailController.text.trim().isEmpty) {
  errorMessage.value = 'Please enter your email';
  return false;
}

if (!GetUtils.isEmail(emailController.text.trim())) {
  errorMessage.value = 'Invalid email format';
  return false;
}

if (passwordController.text.length < 6) {
  errorMessage.value =
      'Password must be at least 6 characters';
  return false;
}

if (passwordController.text !=
    confirmPasswordController.text) {
  errorMessage.value = 'Passwords do not match';
  return false;
}

return true;


}

// ─── Toggle UI ─────────────────────────────────────────────────

void togglePasswordVisibility() {
isPasswordVisible.value =
!isPasswordVisible.value;
}

void toggleConfirmPasswordVisibility() {
isConfirmPasswordVisible.value =
!isConfirmPasswordVisible.value;
}

void toggleRememberMe() {
rememberMe.value = !rememberMe.value;
}

// ─── Clear Form ────────────────────────────────────────────────

void clearForm() {
emailController.clear();
passwordController.clear();
nameController.clear();
confirmPasswordController.clear();


errorMessage.value = '';


}

// ─── Dispose ───────────────────────────────────────────────────

@override
void onClose() {
emailController.dispose();
passwordController.dispose();
nameController.dispose();
confirmPasswordController.dispose();


super.onClose();


}
}
