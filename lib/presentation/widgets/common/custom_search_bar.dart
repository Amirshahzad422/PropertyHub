import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class CustomSearchBar extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.hintText = 'Search by city, neighborhood...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: readOnly ? 12 : 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: readOnly
                      ? Text(
                          hintText,
                          style: AppTypography.bodyMedium,
                        )
                      : TextField(
                          controller: controller,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          style: AppTypography.bodyMedium,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
