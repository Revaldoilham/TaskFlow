import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/user_repository.dart';
import 'auth_controller.dart';

class UserController extends GetxController {
  final UserRepository _userRepo = UserRepository();

  // ─── Reactive State ─────────────────────────────────────────────
  final RxBool isLoadingProfile = false.obs;
  final RxBool isLoadingStats = false.obs;
  final RxBool isLoadingActivities = false.obs;

  final RxMap<String, dynamic> statistics = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> activities = <Map<String, dynamic>>[].obs;

  // ─── Form Controllers untuk Edit Profile ────────────────────────
  final nameEditController = TextEditingController();
  final passwordEditController = TextEditingController();
  final avatarEditController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  // Refresh semua data Users Module
  void refreshAll() {
    fetchStatistics();
    fetchActivities();
  }

  // ─── Fetch Statistics ──────────────────────────────────────────
  Future<void> fetchStatistics() async {
    isLoadingStats.value = true;
    try {
      final statsData = await _userRepo.getStatistics();
      statistics.value = statsData;
    } catch (e) {
      debugPrint('Fetch statistics error: $e');
      // Menggunakan placeholder jika database/server belum menyediakan data statistik
      _loadStatisticsPlaceholder();
    } finally {
      isLoadingStats.value = false;
    }
  }

  void _loadStatisticsPlaceholder() {
    statistics.value = {
      'total_tasks': 0,
      'completed_tasks': 0,
      'todo_tasks': 0,
      'in_progress_tasks': 0,
      'late_tasks': 0,
      'completion_rate_percentage': 0,
    };
  }

  // ─── Fetch Activities ──────────────────────────────────────────
  Future<void> fetchActivities() async {
    isLoadingActivities.value = true;
    try {
      final activitiesData = await _userRepo.getActivities();
      activities.value = activitiesData;

      if (activitiesData.isEmpty) {
        _loadActivitiesPlaceholder();
      }
    } catch (e) {
      debugPrint('Fetch activities error: $e');
      _loadActivitiesPlaceholder();
    } finally {
      isLoadingActivities.value = false;
    }
  }

  void _loadActivitiesPlaceholder() {
    activities.value = [
      {
        'id': 'placeholder_1',
        'action_type': 'WELCOME',
        'description': 'Selamat datang di TaskFlow! Mulai buat tugas baru untuk melihat log aktivitas Anda di sini.',
        'created_at': DateTime.now().toIso8601String(),
      }
    ];
  }

  // ─── Update Profile ────────────────────────────────────────────
  Future<bool> updateProfile() async {
    isLoadingProfile.value = true;
    try {
      final updatedUser = await _userRepo.updateProfile(
        name: nameEditController.text,
        password: passwordEditController.text,
        avatarUrl: avatarEditController.text,
      );

      // Sinkronisasi data user yang diperbarui ke AuthController secara reaktif
      final authCtrl = Get.find<AuthController>();
      authCtrl.currentUser.value = updatedUser;

      Get.snackbar(
        'Sukses',
        'Profil Anda berhasil diperbarui!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );

      // Bersihkan password setelah diupdate demi alasan keamanan
      passwordEditController.clear();
      return true;
    } catch (e) {
      Get.snackbar(
        'Gagal Memperbarui Profil',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ─── Setup Input Form Edit ──────────────────────────────────────
  void prepopulateForm() {
    final authCtrl = Get.find<AuthController>();
    final user = authCtrl.currentUser.value;
    if (user != null) {
      nameEditController.text = user.name;
      avatarEditController.text = user.avatar ?? '';
    }
    passwordEditController.clear();
  }

  @override
  void onClose() {
    nameEditController.dispose();
    passwordEditController.dispose();
    avatarEditController.dispose();
    super.onClose();
  }
}
