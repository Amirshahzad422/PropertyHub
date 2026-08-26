import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/providers/places_provider.dart';
import 'package:propertyhub/presentation/widgets/common/loader_skeleton.dart';

class NeighbourhoodInsights extends ConsumerWidget {
  final String propertyId;

  const NeighbourhoodInsights({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(nearbyPlacesProvider(propertyId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Neighborhood',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.charcoalText,
          ),
        ),
        const SizedBox(height: 16),
        placesAsync.when(
          loading: () => _buildLoadingSkeleton(),
          error: (err, stack) => _buildErrorState(err.toString(), () {
            ref.invalidate(nearbyPlacesProvider(propertyId));
          }),
          data: (places) {
            if (places.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: places.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final place = places[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconForType(place.type),
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: AppTypography.titleSmall.copyWith(
                                color: AppColors.charcoalText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.vicinity,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (place.rating > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                place.rating.toStringAsFixed(1),
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.amber[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const SkeletonContainer(width: 48, height: 48, borderRadius: 12),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonContainer(width: double.infinity, height: 16, borderRadius: 4),
                      SizedBox(height: 8),
                      SkeletonContainer(width: 120, height: 12, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined, size: 48, color: AppColors.outlineVariant),
          const SizedBox(height: 12),
          Text(
            'No nearby places found',
            style: AppTypography.titleMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.errorContainer),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 32),
          const SizedBox(height: 12),
          Text(
            'Failed to load nearby places',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'school':
        return Icons.school;
      case 'hospital':
        return Icons.local_hospital;
      case 'restaurant':
        return Icons.restaurant;
      case 'transit_station':
        return Icons.directions_transit;
      default:
        return Icons.place;
    }
  }
}
