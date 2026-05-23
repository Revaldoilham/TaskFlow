// lib/core/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:taskflow/constants/app_colors.dart';
import 'package:taskflow/constants/app_constants.dart';

import 'package:taskflow/controllers/task_controller.dart';

import 'package:taskflow/models/task_model.dart';

import 'package:taskflow/widgets/app_widgets.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final bool showProject;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.showProject = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(AppConstants.taskDetailRoute, arguments: task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
          border: Border.all(
            color: task.isOverdue
                ? AppColors.error.withOpacity(0.2)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Priority indicator line
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PriorityBadge(priority: task.priority, compact: true),
                      const SizedBox(width: 8),
                      StatusBadge(status: task.status),
                      const Spacer(),
                      _buildOptionsMenu(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    task.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: task.isDone
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textHint,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (task.deadline != null) ...[
                        Icon(
                          Icons.schedule_outlined,
                          size: 13,
                          color: task.isOverdue ? AppColors.error : AppColors.textHint,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat('MMM d').format(task.deadline!),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: task.isOverdue ? AppColors.error : AppColors.textHint,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (showProject && task.projectName != null) ...[
                        const Icon(Icons.folder_outlined, size: 13, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            task.projectName!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w500,
                              color: AppColors.textHint,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (task.assignedName != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  task.assignedName![0].toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10, fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _priorityColor {
    switch (task.priority) {
      case 'Low': return AppColors.priorityLow;
      case 'Medium': return AppColors.priorityMedium;
      case 'High': return AppColors.priorityHigh;
      case 'Urgent': return AppColors.priorityUrgent;
      default: return AppColors.textHint;
    }
  }

  Widget _buildOptionsMenu() {
    final TaskController controller = Get.find<TaskController>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 18, color: AppColors.textHint),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            controller.prepareEditTask(task);
            Get.toNamed(AppConstants.editTaskRoute, arguments: task);
            break;
          case 'done':
            await controller.updateStatus(task.id, 'Done');
            break;
          case 'delete':
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('Delete Task',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                content: Text('Are you sure you want to delete this task?',
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary)),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteTask(task.id);
                    },
                    child: Text('Delete',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.error, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(children: [
            const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Edit', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
          ]),
        ),
        if (task.status != 'Done')
          PopupMenuItem(
            value: 'done',
            child: Row(children: [
              const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Text('Mark Done', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
            ]),
          ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
            const SizedBox(width: 8),
            Text('Delete', style: GoogleFonts.plusJakartaSans(
              fontSize: 13, color: AppColors.error)),
          ]),
        ),
      ],
    );
  }
}