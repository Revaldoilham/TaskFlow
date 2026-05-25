// app colors
// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {

  // ─────────────────────────────────────
  // PRIMARY
  // ─────────────────────────────────────

  static const Color primary =
      Color(0xFF2563EB);

  static const Color primaryLight =
      Color(0xFF60A5FA);

  static const Color primaryDark =
      Color(0xFF1D4ED8);

  static const Color primarySurface =
      Color(0xFFEFF6FF);

  // ─────────────────────────────────────
  // BACKGROUND
  // ─────────────────────────────────────

  static const Color background =
      Color(0xFFF5F9FF);

  static const Color backgroundDark =
      Color(0xFF0F172A);

  // ─────────────────────────────────────
  // CARD / SURFACE
  // ─────────────────────────────────────

  static const Color card =
      Color(0xFFFFFFFF);

  static const Color cardDark =
      Color(0xFF1E293B);

  static const Color darkInputBg =
      Color(0xFF1E293B);

  static const Color lightInputBg =
      Color(0xFFF8FAFC);

  // ─────────────────────────────────────
  // TEXT
  // ─────────────────────────────────────

  static const Color textPrimary =
      Color(0xFF0F172A);

  static const Color textSecondary =
      Color(0xFF64748B);

  static const Color textHint =
      Color(0xFF94A3B8);

  static const Color textOnPrimary =
      Color(0xFFFFFFFF);

  // ─────────────────────────────────────
  // STATUS
  // ─────────────────────────────────────

  static const Color success =
      Color(0xFF10B981);

  static const Color warning =
      Color(0xFFF59E0B);

  static const Color error =
      Color(0xFFEF4444);

  static const Color info =
      Color(0xFF06B6D4);

  // ─────────────────────────────────────
  // PRIORITY
  // ─────────────────────────────────────

  static const Color priorityLow =
      Color(0xFF10B981);

  static const Color priorityMedium =
      Color(0xFF3B82F6);

  static const Color priorityHigh =
      Color(0xFFF59E0B);

  static const Color priorityUrgent =
      Color(0xFFEF4444);

  // ─────────────────────────────────────
  // TASK STATUS
  // ─────────────────────────────────────

  static const Color statusTodo =
      Color(0xFF94A3B8);

  static const Color statusInProgress =
      Color(0xFF3B82F6);

  static const Color statusReview =
      Color(0xFFF59E0B);

  static const Color statusDone =
      Color(0xFF10B981);

  // ─────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────

  static const LinearGradient
      primaryGradient =
      LinearGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );

  static const LinearGradient
      splashGradient =
      LinearGradient(
    colors: [
      Color(0xFF1D4ED8),
      Color(0xFF2563EB),
      Color(0xFF3B82F6),
    ],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );

  static const LinearGradient
      cardGradient =
      LinearGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF60A5FA),
    ],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────
  // SHADOWS
  // ─────────────────────────────────────

  static List<BoxShadow>
      cardShadow = [

    BoxShadow(
      color:
          Colors.black.withValues(
        alpha: 0.06,
      ),

      blurRadius: 16,

      offset:
          const Offset(0, 4),
    ),
  ];

  static List<BoxShadow>
      primaryShadow = [

    BoxShadow(
      color:
          primary.withValues(
        alpha: 0.30,
      ),

      blurRadius: 20,

      offset:
          const Offset(0, 8),
    ),
  ];

  static List<BoxShadow>
      elevatedShadow = [

    BoxShadow(
      color:
          Colors.black.withValues(
        alpha: 0.08,
      ),

      blurRadius: 24,

      offset:
          const Offset(0, 8),
    ),
  ];
}