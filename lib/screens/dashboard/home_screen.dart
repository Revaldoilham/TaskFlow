import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/auth_controller.dart';
import 'package:taskflow/controllers/dashboard_controller.dart';
import 'package:taskflow/controllers/project_controller.dart';
import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/widgets/project_card.dart';
import 'package:taskflow/widgets/task_card.dart';
import 'package:taskflow/widgets/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashCtrl = Get.find<DashboardController>();
    final taskCtrl = Get.find<TaskController>();
    final projectCtrl = Get.find<ProjectController>();
    final authCtrl = Get.find<AuthController>();

    final stats = taskCtrl.stats.value;
    final total = stats['total'] ?? 0;
    final done = stats['done'] ?? 0;
    final progress = total > 0 ? done / total : 0.0;

    final activeProjects = projectCtrl.activeProjects;
    final upcoming = taskCtrl.upcomingTasks.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await taskCtrl.loadTasks();
          await projectCtrl.loadProjects();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                '${dashCtrl.greeting},',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                dashCtrl.userName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // AVATAR
                        GestureDetector(
                          onTap: () => dashCtrl.changeTab(3),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                authCtrl.currentUser.value?.initials ?? 'U',
                                style:
                                    GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // SEARCH
                    GestureDetector(
                      onTap: () => dashCtrl.changeTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [

                            Icon(
                              Icons.search,
                              color: Colors.white
                                  .withOpacity(0.8),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              'Cari tugas & proyek...',
                              style:
                                  GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: Colors.white
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // STATS
                    Row(
                      children: [

                        _StatCard(
                          label: 'Total',
                          value: '$total',
                          color: AppColors.primary,
                          icon:
                              Icons.assignment_outlined,
                        ),

                        const SizedBox(width: 10),

                        _StatCard(
                          label: 'Selesai',
                          value: '$done',
                          color: AppColors.success,
                          icon:
                              Icons.check_circle_outline,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // PROGRESS
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient:
                            AppColors.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Progress Keseluruhan',
                            style:
                                GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '$done dari $total tugas selesai',
                            style:
                                GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // PROJECT
                    const SectionHeader(
                      title: 'Proyek Aktif',
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 168,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            activeProjects.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            ProjectCard(
                          project: activeProjects[i],
                          compact: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TASK
                    const SectionHeader(
                      title: 'Tugas Mendatang',
                    ),

                    const SizedBox(height: 12),

                    if (upcoming.isEmpty)
                      const EmptyState(
                        title: 'Tidak ada tugas',
                        subtitle:
                            'Tugas akan muncul disini',
                        icon:
                            Icons.assignment_outlined,
                      )
                    else
                      ...upcoming.map(
                        (task) => TaskCard(task: task),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}