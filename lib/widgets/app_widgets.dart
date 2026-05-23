// lib/core/widgets/app_widgets.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

// ─── GRADIENT BUTTON ────────────────────────────────────────────────────────

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(colors: [Color(0xFF93C5FD), Color(0xFF60A5FA)])
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading ? [] : AppColors.primaryShadow,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(text,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── CUSTOM TEXT FIELD ───────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textPrimary),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14, vertical: maxLines > 1 ? 12 : 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── APP CARD ────────────────────────────────────────────────────────────────

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.card,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: AppColors.cardShadow,
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// ─── PRIORITY BADGE ─────────────────────────────────────────────────────────

class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool compact;

  const PriorityBadge({super.key, required this.priority, this.compact = false});

  Color get _color {
    switch (priority) {
      case 'Low': return AppColors.priorityLow;
      case 'Medium': return AppColors.priorityMedium;
      case 'High': return AppColors.priorityHigh;
      case 'Urgent': return AppColors.priorityUrgent;
      default: return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10, vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(priority,
            style: GoogleFonts.plusJakartaSans(
              fontSize: compact ? 10 : 11, fontWeight: FontWeight.w600, color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STATUS BADGE ────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'Todo': return AppColors.statusTodo;
      case 'In Progress': return AppColors.statusInProgress;
      case 'Review': return AppColors.statusReview;
      case 'Done': return AppColors.statusDone;
      default: return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(status,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w600, color: _color,
        ),
      ),
    );
  }
}

// ─── SKELETON LOADER ─────────────────────────────────────────────────────────

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// ─── SKELETON CARD ───────────────────────────────────────────────────────────

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonLoader(width: 60, height: 20, radius: 20),
              const Spacer(),
              SkeletonLoader(width: 24, height: 24, radius: 6),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLoader(width: double.infinity, height: 16),
          const SizedBox(height: 6),
          const SkeletonLoader(width: 200, height: 14),
          const SizedBox(height: 12),
          Row(
            children: [
              const SkeletonLoader(width: 80, height: 28, radius: 8),
              const SizedBox(width: 8),
              const SkeletonLoader(width: 80, height: 28, radius: 8),
              const Spacer(),
              const SkeletonLoader(width: 24, height: 24, radius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary.withOpacity(0.6)),
            ),
            const SizedBox(height: 20),
            Text(title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5,
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              GradientButton(text: actionLabel!, onTap: onAction, width: 160),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key, required this.title, this.actionLabel, this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── AVATAR GROUP ────────────────────────────────────────────────────────────

class AvatarGroup extends StatelessWidget {
  final List<String> names;
  final double size;
  final int maxVisible;

  const AvatarGroup({
    super.key,
    required this.names,
    this.size = 28,
    this.maxVisible = 4,
  });

  Color _colorForName(String name) {
    final colors = [
      const Color(0xFF2563EB), const Color(0xFF7C3AED), const Color(0xFF059669),
      const Color(0xFFDC2626), const Color(0xFFD97706), const Color(0xFF0891B2),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final visible = names.take(maxVisible).toList();
    final remaining = names.length - maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < visible.length; i++)
          Transform.translate(
            offset: Offset(-i * size * 0.35, 0),
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(
                color: _colorForName(visible[i]),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  visible[i].isNotEmpty ? visible[i][0].toUpperCase() : '?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: size * 0.38, fontWeight: FontWeight.w700, color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if (remaining > 0)
          Transform.translate(
            offset: Offset(-visible.length * size * 0.35, 0),
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text('+$remaining',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: size * 0.3, fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}