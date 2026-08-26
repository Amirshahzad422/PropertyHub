import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/common/loader_skeleton.dart';
import 'package:propertyhub/presentation/widgets/property/property_card.dart';

class HomeRecommendedProperties extends ConsumerWidget {
  const HomeRecommendedProperties({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(homePropertiesProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for You',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Based on your selection',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        SizedBox(
          height: 420,
          child: propertiesAsync.when(
            data: (properties) {
              if (properties.isEmpty) {
                return const Center(child: Text('No properties found.'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final prop = properties[index];
                  return PropertyCard(
                    width: 320,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    property: prop,
                    onFavoriteTap: () {},
                  );
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const SizedBox(
                  width: 320,
                  child: PropertyCardSkeleton(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              },
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load properties', style: AppTypography.bodyLarge),
                  TextButton(
                    onPressed: () => ref.refresh(homePropertiesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
