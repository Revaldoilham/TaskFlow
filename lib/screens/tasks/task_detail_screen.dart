// lib/modules/tasks/detail/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/widgets/app_widgets.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = Get.arguments as TaskModel;
    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        PriorityBadge(priority: task.priority),
                        const SizedBox(width: 8),
                        StatusBadge(status: task.status),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Get.snackbar(
                    'Info',
                    'Fitur edit task belum tersedia',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'delete') {
                    Get.dialog(AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: Text('Hapus Tugas',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700)),
                      content: Text('Tindakan ini tidak dapat dibatalkan.',
                          style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textSecondary)),
                      actions: [
                        TextButton(
                            onPressed: Get.back,
                            child: Text('Batal',
                                style: GoogleFonts.plusJakartaSans())),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.deleteTask(task.id);
                            Get.back();
                          },
                          child: Text('Hapus  ',
                              style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'Hapus',
                    child: Row(children: [
                      const Icon(Icons.delete_outline,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text('Hapus Tugas',
                          style: GoogleFonts.plusJakartaSans(
                              color: AppColors.error, fontSize: 13)),
                    ]),
                  ),
                ],
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
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

                  // Details Grid
                  _DetailCard(
                    title: 'Detail Tugas',
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.flag_outlined,
                          label: 'Prioritas',
                          value: task.priority,
                          valueColor: _priorityColor(task.priority),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.radio_button_checked_outlined,
                          label: 'Status Tugas',
                          value: task.status,
                          valueColor: _statusColor(task.status),
                        ),
                        if (task.deadline != null) ...[
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Deadline',
                            value: DateFormat('MMM d, yyyy')
                                .format(task.deadline!),
                            valueColor: task.isOverdue
                                ? AppColors.error
                                : AppColors.textPrimary,
                            trailing: task.isOverdue
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Overdue',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                        if (task.assignedName != null) ...[
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Icons.person_outline,
                            label: 'Ditugaskan kepada',
                            value: task.assignedName!,
                          ),
                        ],
                        if (task.projectName != null) ...[
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Icons.folder_outlined,
                            label: 'Proyek',
                            value: task.projectName!,
                            valueColor: AppColors.primary,
                          ),
                        ],
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.access_time_outlined,
                          label: 'Dibuat',
                          value:
                              DateFormat('MMM d, yyyy').format(task.createdAt),
                        ),
                      ],
                    ),
                  ),

                  // Tags
                  if (task.tags.isNotEmpty)
                    _DetailCard(
                      title: 'Tag',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: task.tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            AppColors.primary.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  // Change Status
                  _DetailCard(
                    title: 'Ubah Status',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.statuses.map((s) {
                        final isActive = task.status == s;
                        return GestureDetector(
                          onTap: isActive
                              ? null
                              : () async {
                                  await controller.updateStatus(task.id, s);
                                  Get.back();
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? _statusColor(s)
                                  : _statusColor(s).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive
                                    ? _statusColor(s)
                                    : _statusColor(s).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              s,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    isActive ? Colors.white : _statusColor(s),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'Low':
        return AppColors.priorityLow;
      case 'Medium':
        return AppColors.priorityMedium;
      case 'High':
        return AppColors.priorityHigh;
      case 'Urgent':
        return AppColors.priorityUrgent;
      default:
        return AppColors.textHint;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Todo':
        return AppColors.statusTodo;
      case 'In Progress':
        return AppColors.statusInProgress;
      case 'Review':
        return AppColors.statusReview;
      case 'Done':
        return AppColors.statusDone;
      default:
        return AppColors.textHint;
    }
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 12),
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
  final Widget? trailing;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: 10),
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
        if (trailing != null) ...[const SizedBox(width: 6), trailing!],
      ],
    );
  }
}
