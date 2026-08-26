import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/place_model.dart';

class NearbyPlacesBottomSheet extends StatelessWidget {
  final List<PlaceModel> places;

  const NearbyPlacesBottomSheet({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Neighbourhood Insights',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Places near this property',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: places.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  leading: Icon(
                    _getIconForType(place.type),
                    color: AppColors.primary,
                  ),
                  title: Text(place.name),
                  subtitle: Text(place.vicinity),
                  trailing: Text(
                    place.rating > 0 ? '⭐ ${place.rating.toStringAsFixed(1)}' : '',
                    style: AppTypography.labelMedium,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getIconForType(String? type) {
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
