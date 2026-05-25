// lib/modules/tasks/detail/task_detail_screen.dart

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/models/local_task_model.dart';

import 'package:taskflow/widgets/app_widgets.dart';
import 'package:taskflow/controllers/create_task_controller.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final args = Get.arguments;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: Center(
          child: Text(
            'Task tidak ditemukan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final LocalTaskModel task = args as LocalTaskModel;

    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // APP BAR

          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  80,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        PriorityBadge(
                          priority: task.priority,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        StatusBadge(
                          status: task.status,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      task.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                onPressed: () {
                  final createCtrl = Get.find<CreateTaskController>();

                  createCtrl.prepareEdit(
                    task,
                  );

                  Get.toNamed(
                    '/create-task',
                    arguments: task,
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
                onSelected: (
                  value,
                ) {
                  if (value == 'delete') {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                        title: Text(
                          'Hapus Tugas',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: Text(
                          'Tindakan ini tidak dapat dibatalkan.',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: Get.back,
                            child: Text(
                              'Batal',
                              style: GoogleFonts.plusJakartaSans(),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();

                              controller.deleteTask(
                                task.id,
                              );

                              Get.back();
                            },
                            child: Text(
                              'Hapus',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: AppColors.error,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Hapus Tugas',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty)
                    _DetailCard(
                      title: 'Deskripsi',
                      child: Text(
                        task.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  _DetailCard(
                    title: 'Detail Tugas',
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.flag_outlined,
                          label: 'Prioritas',
                          value: task.priority,
                          valueColor: _priorityColor(
                            task.priority,
                          ),
                        ),
                        const Divider(
                          height: 20,
                        ),
                        _DetailRow(
                          icon: Icons.radio_button_checked_outlined,
                          label: 'Status Tugas',
                          value: task.status,
                          valueColor: _statusColor(
                            task.status,
                          ),
                        ),
                        if (task.deadline != null) ...[
                          const Divider(
                            height: 20,
                          ),
                          _DetailRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Deadline',
                            value: DateFormat(
                              'dd/MM/yyyy',
                            ).format(
                              task.deadline!,
                            ),
                            valueColor: task.isOverdue
                                ? AppColors.error
                                : AppColors.textPrimary,
                          ),
                        ],
                        if (task.categoryName != null) ...[
                          const Divider(
                            height: 20,
                          ),
                          _DetailRow(
                            icon: Icons.folder_outlined,
                            label: 'Kategori',
                            value: task.categoryName!,
                          ),
                        ],
                        const Divider(
                          height: 20,
                        ),
                        _DetailRow(
                          icon: Icons.access_time_outlined,
                          label: 'Dibuat',
                          value: DateFormat(
                            'dd/MM/yyyy',
                          ).format(
                            task.createdAt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(
    String p,
  ) {
    switch (p) {
      case 'low':
        return AppColors.priorityLow;

      case 'medium':
        return AppColors.priorityMedium;

      case 'high':
        return AppColors.priorityHigh;

      default:
        return AppColors.textHint;
    }
  }

  Color _statusColor(
    String s,
  ) {
    switch (s) {
      case 'todo':
        return AppColors.statusTodo;

      case 'in_progress':
        return AppColors.statusInProgress;

      case 'done':
        return AppColors.statusDone;

      default:
        return AppColors.textHint;
    }
  }
}

class _DetailCard extends StatelessWidget {
  final String title;

  final Widget child;

  const _DetailCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;

  final String label;

  final String value;

  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textHint,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
