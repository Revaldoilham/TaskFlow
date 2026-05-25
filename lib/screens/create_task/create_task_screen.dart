// lib/screens/create_task/create_task_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../controllers/create_task_controller.dart';
import '../../models/local_task_model.dart';
import '../../models/subtask_model.dart';
import '../../widgets/app_widgets.dart';

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateTaskController>();
    final editTask = Get.arguments is LocalTaskModel
        ? Get.arguments as LocalTaskModel
        : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If editing, preload
    if (editTask != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ctrl.editingTask?.id != editTask.id) {
          ctrl.prepareEdit(editTask);
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ctrl.editingTask == null) ctrl.initForNew();
      });
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text(
          ctrl.editingTask != null ? 'Edit Task' : 'Buat Task Baru',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.background,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
        actions: [
          Obx(() => TextButton(
                onPressed: ctrl.isSubmitting.value ? null : ctrl.saveTask,
                child: ctrl.isSubmitting.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      )
                    : Text(
                        'Simpan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Judul ───────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: AppTextField(
                label: 'Judul Task *',
                hint: 'Apa yang perlu dikerjakan?',
                controller: ctrl.titleController,
              ),
            ),

            // ─── Deskripsi ───────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: AppTextField(
                label: 'Deskripsi',
                hint: 'Tambahkan detail task...',
                controller: ctrl.descController,
                maxLines: 3,
              ),
            ),

            // ─── Kategori ────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Kategori', isDark),
                  const SizedBox(height: 10),
                  Obx(() => ctrl.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _CategoryChip(
                                label: 'Tidak ada',
                                isSelected: ctrl.selectedCategory.value == null,
                                color: AppColors.textHint,
                                onTap: () => ctrl.selectedCategory.value = null,
                              ),
                              ...ctrl.categories.map((c) {
                                final color = Color(int.parse(
                                    'FF${c.color.replaceFirst('#', '')}',
                                    radix: 16));
                                return _CategoryChip(
                                  label: c.name,
                                  isSelected:
                                      ctrl.selectedCategory.value?.id == c.id,
                                  color: color,
                                  onTap: () => ctrl.selectedCategory.value = c,
                                );
                              }),
                            ],
                          ),
                        )),
                ],
              ),
            ),

            // ─── Prioritas ───────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Prioritas', isDark),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                        children: AppConstants.localPriorities.map((p) {
                          final label = AppConstants.priorityLabels[p]!;
                          final isSelected = ctrl.priority.value == p;
                          Color color;
                          switch (p) {
                            case 'high':
                              color = AppColors.priorityHigh;
                              break;
                            case 'medium':
                              color = AppColors.priorityMedium;
                              break;
                            default:
                              color = AppColors.priorityLow;
                          }
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => ctrl.priority.value = p,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color
                                      : color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : color.withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? Colors.white : color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),

            // ─── Tanggal ─────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Tanggal', isDark),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => _DateField(
                              label: 'Mulai',
                              value: ctrl.startDate.value,
                              isDark: isDark,
                              onTap: () async {
                                final d = await _pickDate(context);
                                if (d != null) ctrl.startDate.value = d;
                              },
                              onClear: () => ctrl.startDate.value = null,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => _DateField(
                              label: 'Deadline',
                              value: ctrl.deadline.value,
                              isDark: isDark,
                              isDeadline: true,
                              onTap: () async {
                                final d = await _pickDate(context);
                                if (d != null) ctrl.deadline.value = d;
                              },
                              onClear: () => ctrl.deadline.value = null,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Jam ─────────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Jam Mulai & Selesai', isDark),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => _TimeField(
                              label: 'Jam Mulai',
                              value: ctrl.startTime.value,
                              isDark: isDark,
                              onTap: () async {
                                final t = await _pickTime(context);
                                if (t != null) ctrl.startTime.value = t;
                              },
                              onClear: () => ctrl.startTime.value = '',
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => _TimeField(
                              label: 'Jam Selesai',
                              value: ctrl.endTime.value,
                              isDark: isDark,
                              onTap: () async {
                                final t = await _pickTime(context);
                                if (t != null) ctrl.endTime.value = t;
                              },
                              onClear: () => ctrl.endTime.value = '',
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Reminder & Repeat ───────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                children: [
                  // Reminder toggle
                  Obx(() => Row(
                        children: [
                          Icon(Icons.notifications_outlined,
                              size: 20, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pengingat Task',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Switch(
                            value: ctrl.reminderEnabled.value,
                            onChanged: (v) => ctrl.reminderEnabled.value = v,
                            activeColor: AppColors.primary,
                          ),
                        ],
                      )),
                  const Divider(height: 20),
                  // Repeat
                  Row(
                    children: [
                      const Icon(Icons.repeat,
                          size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Text(
                        'Pengulangan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppConstants.repeatOptions.map((r) {
                          final label = AppConstants.repeatLabels[r]!;
                          final isSelected = ctrl.repeat.value == r;
                          return GestureDetector(
                            onTap: () => ctrl.repeat.value = r,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.primary.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),

            // ─── Subtask ──────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Subtask', isDark),
                  const SizedBox(height: 10),
                  // Input subtask
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hint: 'Tambah subtask...',
                          controller: ctrl.subtaskController,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add_circle,
                                color: AppColors.primary),
                            onPressed: ctrl.addSubtask,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Subtask list
                  Obx(() {
                    if (ctrl.subtasks.isEmpty) {
                      return Text(
                        'Belum ada subtask',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      );
                    }
                    return ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: ctrl.reorderSubtask,
                      itemCount: ctrl.subtasks.length,
                      itemBuilder: (ctx, i) {
                        final sub = ctrl.subtasks[i];
                        return _SubtaskItem(
                          key: ValueKey(i),
                          subtask: sub,
                          index: i,
                          isDark: isDark,
                          onRemove: () => ctrl.removeSubtask(i),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            // ─── Save Button ──────────────────────────────────────────
            const SizedBox(height: 8),
            Obx(() => GradientButton(
                  text: ctrl.editingTask != null
                      ? 'Simpan Perubahan'
                      : 'Buat Task',
                  isLoading: ctrl.isSubmitting.value,
                  onTap: ctrl.saveTask,
                  icon: ctrl.editingTask == null
                      ? const Icon(Icons.add, color: Colors.white, size: 18)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
  }

  Future<String?> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return null;
    return '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SectionCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : AppColors.cardShadow,
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isDark;

  const _FieldLabel(this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white70 : AppColors.textSecondary,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final bool isDark;
  final bool isDeadline;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateField({
    required this.label,
    required this.value,
    required this.isDark,
    this.isDeadline = false,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkInputBg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value != null
                ? (isDeadline
                    ? AppColors.error.withOpacity(0.4)
                    : AppColors.primary.withOpacity(0.4))
                : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: value != null
                  ? (isDeadline ? AppColors.error : AppColors.primary)
                  : AppColors.textHint,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
                  Text(
                    value != null
                        ? DateFormat('d MMM y').format(value!)
                        : 'Pilih tanggal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: value != null
                          ? (isDeadline ? AppColors.error : AppColors.primary)
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 14, color: AppColors.textHint),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _TimeField({
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkInputBg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? AppColors.primary.withOpacity(0.4)
                : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 14,
              color: hasValue ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10, color: AppColors.textHint),
                  ),
                  Text(
                    hasValue ? value : '--:--',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: hasValue ? AppColors.primary : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 14, color: AppColors.textHint),
              ),
          ],
        ),
      ),
    );
  }
}

class _SubtaskItem extends StatelessWidget {
  final SubtaskModel subtask;
  final int index;
  final bool isDark;
  final VoidCallback onRemove;

  const _SubtaskItem({
    super.key,
    required this.subtask,
    required this.index,
    required this.isDark,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputBg : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textHint, width: 1.5),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              subtask.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 16, color: AppColors.textHint),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.drag_handle, size: 16, color: AppColors.textHint),
        ],
      ),
    );
  }
}
