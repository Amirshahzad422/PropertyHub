import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: AppTypography.titleMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search query',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
