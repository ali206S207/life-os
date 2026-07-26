import 'package:flutter/material.dart';

/// Centralized color palette for Life OS.
///
/// Dark mode is the primary experience; light mode values are provided
/// for completeness but the app is designed dark-first.
class AppColors {
  AppColors._();

  // --- Brand / accent gradient ---
  static const Color primary = Color(0xFF7C5CFF); // violet
  static const Color primaryLight = Color(0xFF9C85FF);
  static const Color secondary = Color(0xFF00E0B8); // teal accent
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF5C6C);
  static const Color success = Color(0xFF33D69F);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C5CFF), Color(0xFF00E0B8)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7A5C), Color(0xFFFFB020)],
  );

  // --- Dark surfaces ---
  static const Color darkBackground = Color(0xFF0B0B0F);
  static const Color darkSurface = Color(0xFF14141B);
  static const Color darkSurfaceElevated = Color(0xFF1C1C26);
  static const Color darkBorder = Color(0xFF2A2A36);

  // --- Glass ---
  static Color glassFill = Colors.white.withOpacity(0.06);
  static Color glassBorder = Colors.white.withOpacity(0.10);

  // --- Text (dark mode) ---
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA0A0AD);
  static const Color textMuted = Color(0xFF6B6B78);

  // --- Light surfaces (secondary support) ---
  static const Color lightBackground = Color(0xFFF7F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE6E6EC);
  static const Color lightTextPrimary = Color(0xFF14141B);
  static const Color lightTextSecondary = Color(0xFF6B6B78);

  // --- Life-area accent colors (used for area cards, heatmaps, charts) ---
  static const Color areaFitness = Color(0xFFFF5C6C);
  static const Color areaLearning = Color(0xFF4C8BFF);
  static const Color areaCareer = Color(0xFFFFB020);
  static const Color areaFinance = Color(0xFF33D69F);
  static const Color areaRelationships = Color(0xFFFF7AC6);
  static const Color areaMentalHealth = Color(0xFF9C85FF);
  static const Color areaSpiritual = Color(0xFF00C2A8);
  static const Color areaFun = Color(0xFFFFD166);
}
