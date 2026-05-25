import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

import '../../controllers/task_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen
    extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    final taskCtrl =
        Get.find<TaskController>();

    final authCtrl =
        Get.find<AuthController>();

    final userCtrl =
        Get.find<UserController>();

    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
          isDark

              ? AppColors
                  .backgroundDark

              : AppColors
                  .background,

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets
                  .all(
            20,
          ),

          child: Column(

            children: [

              // HEADER

              Container(

                padding:
                    const EdgeInsets
                        .all(
                  24,
                ),

                decoration:
                    BoxDecoration(

                  gradient:
                      AppColors
                          .primaryGradient,

                  borderRadius:
                      BorderRadius
                          .circular(
                    28,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          AppColors
                              .primary
                              .withOpacity(
                        0.25,
                      ),

                      blurRadius:
                          24,

                      offset:
                          const Offset(
                        0,
                        12,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    // AVATAR
                    Obx(() {
                      final user = authCtrl.currentUser.value;
                      final hasAvatar = user?.avatar != null && user!.avatar!.isNotEmpty;
                      return Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: hasAvatar
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    user.avatar!,
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Text(
                                      user.initials,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  user?.initials ?? 'U',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 18,
                    ),

                    Obx(() {
                      final user = authCtrl.currentUser.value;
                      return Text(
                        user?.name ?? 'TaskFlow User',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 6,
                    ),

                    Obx(() {
                      final user = authCtrl.currentUser.value;
                      return Text(
                        user?.email ?? 'Manage Your Productivity Smarter',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // STATS
              Obx(() {
                final stats = userCtrl.statistics;
                final total = stats['total_tasks'] ?? taskCtrl.tasks.length;
                final completed = stats['completed_tasks'] ?? taskCtrl.tasks.where((t) => t.isDone).length;
                final pending = stats['todo_tasks'] ?? taskCtrl.tasks.where((t) => !t.isDone).length;
                final progressRate = stats['completion_rate_percentage'] ?? _calculateProgress(taskCtrl);

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total',
                            value: total.toString(),
                            icon: Icons.task_alt_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Done',
                            value: completed.toString(),
                            icon: Icons.check_circle_rounded,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Pending',
                            value: pending.toString(),
                            icon: Icons.schedule_rounded,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Progress',
                            value: '$progressRate%',
                            icon: Icons.insights_rounded,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(
                height: 26,
              ),

              // MENU

              _MenuTile(

                icon:
                    Icons
                        .edit_rounded,

                title:
                    'Edit Profile',

                subtitle:
                    'Ubah data profile',

                onTap: () => _showEditProfileDialog(context, userCtrl),
              ),

              _MenuTile(

                icon:
                    Icons
                        .dark_mode_rounded,

                title:
                    'Dark Mode',

                subtitle:
                    'Atur tampilan aplikasi',

                onTap: () {

                  Get.changeThemeMode(

                    Get.isDarkMode

                        ? ThemeMode
                            .light

                        : ThemeMode
                            .dark,
                  );
                },
              ),

              _MenuTile(

                icon:
                    Icons
                        .notifications_rounded,

                title:
                    'Notifications',

                subtitle:
                    'Pengaturan notifikasi',

                onTap: () {},
              ),

              _MenuTile(

                icon:
                    Icons
                        .info_rounded,

                title:
                    'About App',

                subtitle:
                    'TaskFlow v1.0',

                onTap: () {},
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Aktivitas Terbaru 📜',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    onPressed: userCtrl.fetchActivities,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (userCtrl.isLoadingActivities.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final list = userCtrl.activities;
                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Center(
                      child: Text(
                        'Belum ada aktivitas tercatat.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length > 5 ? 5 : list.length,
                  itemBuilder: (context, index) {
                    final act = list[index];
                    final String type = act['action_type'] ?? 'INFO';
                    final String desc = act['description'] ?? '';
                    final String dateStr = act['created_at'] ?? '';
                    
                    IconData icon = Icons.info_outline;
                    Color color = AppColors.info;
                    if (type == 'CREATE_TASK') {
                      icon = Icons.add_circle_outline_rounded;
                      color = AppColors.primary;
                    } else if (type == 'COMPLETE_TASK') {
                      icon = Icons.check_circle_outline_rounded;
                      color = AppColors.success;
                    } else if (type == 'DELETE_TASK') {
                      icon = Icons.delete_outline_rounded;
                      color = AppColors.error;
                    } else if (type == 'WELCOME') {
                      icon = Icons.celebration_rounded;
                      color = AppColors.warning;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: color, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  desc,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateStr.isNotEmpty 
                                      ? dateStr.substring(0, 10) + ' ' + dateStr.substring(11, 16) 
                                      : 'Baru saja',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),

              const SizedBox(
                height: 24,
              ),

              // LOGOUT

              GestureDetector(

                onTap: authCtrl.logout,

                child: Container(

                  height: 56,

                  decoration:
                      BoxDecoration(

                    color:
                        AppColors
                            .error,

                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),

                  child: Center(

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        const Icon(
                          Icons
                              .logout_rounded,

                          color:
                              Colors
                                  .white,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(

                          'Logout',

                          style:
                              GoogleFonts
                                  .plusJakartaSans(

                            fontSize:
                                15,

                            fontWeight:
                                FontWeight
                                    .w700,

                            color:
                                Colors
                                    .white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateProgress(
    TaskController ctrl,
  ) {

    if (ctrl.tasks.isEmpty) {
      return 0;
    }

    final done =
        ctrl.tasks.where(
      (task) {

        return task.isDone;
      },
    ).length;

    return ((done /
                ctrl.tasks.length) *
            100)
        .toInt();
  }

  void _showEditProfileDialog(BuildContext context, UserController userCtrl) {
    userCtrl.prepopulateForm();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profil ✏️',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Perbarui nama atau foto profil Anda',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: userCtrl.nameEditController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama baru',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userCtrl.avatarEditController,
                decoration: InputDecoration(
                  labelText: 'Avatar URL',
                  hintText: 'https://example.com/avatar.png',
                  prefixIcon: const Icon(Icons.image_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userCtrl.passwordEditController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru (Opsional)',
                  hintText: 'Kosongkan jika tidak diubah',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: userCtrl.isLoadingProfile.value
                            ? null
                            : () async {
                                final success = await userCtrl.updateProfile();
                                if (success) {
                                  Get.back();
                                }
                              },
                        child: userCtrl.isLoadingProfile.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Simpan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard
    extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const _StatCard({

    required this.title,

    required this.value,

    required this.icon,

    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow:
            AppColors.cardShadow,
      ),

      child: Column(

        children: [

          Container(

            padding:
                const EdgeInsets
                    .all(
              10,
            ),

            decoration:
                BoxDecoration(

              color:
                  color.withOpacity(
                0.12,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                14,
              ),
            ),

            child: Icon(

              icon,

              color: color,

              size: 24,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Text(

            value,

            style:
                GoogleFonts
                    .plusJakartaSans(

              fontSize: 24,

              fontWeight:
                  FontWeight.w800,

              color:
                  AppColors
                      .textPrimary,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(

            title,

            style:
                GoogleFonts
                    .plusJakartaSans(

              fontSize: 12,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile
    extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _MenuTile({

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        padding:
            const EdgeInsets.all(
          16,
        ),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          boxShadow:
              AppColors.cardShadow,
        ),

        child: Row(

          children: [

            Container(

              padding:
                  const EdgeInsets
                      .all(
                12,
              ),

              decoration:
                  BoxDecoration(

                color:
                    AppColors
                        .primarySurface,

                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),
              ),

              child: Icon(

                icon,

                color:
                    AppColors
                        .primary,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    title,

                    style:
                        GoogleFonts
                            .plusJakartaSans(

                      fontSize: 14,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(

                    subtitle,

                    style:
                        GoogleFonts
                            .plusJakartaSans(

                      fontSize: 12,

                      color:
                          AppColors
                              .textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,

              size: 16,

              color:
                  AppColors
                      .textHint,
            ),
          ],
        ),
      ),
    );
  }
}