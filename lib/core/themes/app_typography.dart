import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

class AppTypography {
  // Base Font Families
  static const String serifFont = 'Playfair Display';
  static const String sansFont = 'Inter';

  // --- Headings (Playfair Display) ---
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: serifFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: serifFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: serifFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: serifFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: serifFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // --- Body & Labels (Inter) ---

  static const TextStyle titleMedium = TextStyle(
    fontFamily: sansFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: sansFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: sansFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: sansFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: sansFont,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: sansFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: sansFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: sansFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );
}
