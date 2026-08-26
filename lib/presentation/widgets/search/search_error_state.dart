import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';

class SearchErrorState extends ConsumerWidget {
  const SearchErrorState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text('Failed to search properties', style: AppTypography.bodyLarge),
          TextButton(
            onPressed: () => ref.refresh(searchPropertiesProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
