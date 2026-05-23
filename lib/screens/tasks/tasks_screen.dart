// lib/modules/tasks/list/tasks_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/widgets/task_card.dart';
import 'package:taskflow/widgets/app_widgets.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tugas Saya',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Obx(() => Text(
                                '${controller.filteredTasks.length} tasks',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              )),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.snackbar(
                            'Info',
                            'Fitur tambah task belum tersedia',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppColors.primaryShadow,
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: TextField(
                      onChanged: controller.setSearchQuery,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari tugas...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                        prefixIcon: const Icon(Icons.search,
                            size: 20, color: AppColors.textHint),
                        suffixIcon: Obx(
                          () => controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      size: 18, color: AppColors.textHint),
                                  onPressed: () {
                                    controller.setSearchQuery('');
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Status filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                          children: [
                            {
                              'label': 'Semua',
                              'value': 'All',
                            },
                            {
                              'label': 'Belum Dikerjakan',
                              'value': 'Todo',
                            },
                            {
                              'label': 'Dikerjakan',
                              'value': 'In Progress',
                            },
                            {
                              'label': 'Ditinjau',
                              'value': 'Review',
                            },
                            {
                              'label': 'Selesai',
                              'value': 'Done',
                            },
                          ]
                              .map((s) => _FilterChip(
                                    label: s['label']!,
                                    isSelected:
                                        controller.selectedStatus.value ==
                                            s['value'],
                                    onTap: () => controller.setStatusFilter(
                                      s['value']!,
                                    ),
                                  ))
                              .toList(),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ── Task List ────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: List.generate(5, (_) => const SkeletonCard()),
                  );
                }

                if (controller.filteredTasks.isEmpty) {
                  return EmptyState(
                    title: 'No tasks found',
                    subtitle: controller.searchQuery.value.isNotEmpty
                        ? 'Try a different search term'
                        : 'Tap + to create your first task',
                    icon: Icons.assignment_outlined,
                    actionLabel: 'Add Task',
                    onAction: () {
                      Get.snackbar(
                        'Info',
                        'Fitur tambah task belum tersedia',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.loadTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: controller.filteredTasks.length,
                    itemBuilder: (_, i) =>
                        TaskCard(task: controller.filteredTasks[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              isSelected ? AppColors.primaryShadow : AppColors.cardShadow,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
