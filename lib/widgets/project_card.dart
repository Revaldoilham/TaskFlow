// lib/core/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/models/project_model.dart';
import '/constants/app_colors.dart';
import 'app_widgets.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final bool compact;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.compact = false,
  });

  Color get _projectColor {
    final hex = project.color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact();
    return _buildFull();
  }

  Widget _buildFull() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _projectColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      project.name.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20, fontWeight: FontWeight.w800, color: _projectColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      _buildStatusBadge(),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
              ],
            ),
            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(project.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.4,
                ),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text('${(project.calculatedProgress * 100).toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, fontWeight: FontWeight.w700, color: _projectColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project.calculatedProgress,
                    minHeight: 6,
                    backgroundColor: _projectColor.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(_projectColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // Tasks count
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.task_alt_outlined, size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text('${project.completedTasks}/${project.totalTasks} tasks',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                if (project.deadline != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(DateFormat('MMM d').format(project.deadline!),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                AvatarGroup(names: project.memberNames, size: 26),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_projectColor, _projectColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _projectColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(project.name[0].toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${project.totalTasks} tasks',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(project.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
              ),
              maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: project.calculatedProgress,
                minHeight: 4,
                backgroundColor: Colors.white.withOpacity(0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text('${(project.calculatedProgress * 100).toInt()}% complete',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11, color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    switch (project.status) {
      case 'Active': color = AppColors.success; break;
      case 'On Hold': color = AppColors.warning; break;
      case 'Completed': color = AppColors.primary; break;
      default: color = AppColors.textHint;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(project.status,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10, fontWeight: FontWeight.w600, color: color,
        ),
      ),
    );
  }
}