import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

import 'package:propertyhub/data/models/property_model.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onFavoriteTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.width,
    this.margin,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth = width ?? constraints.maxWidth;
        final isCompact = effectiveWidth < 250;

        return Container(
          width: width,
          margin: margin ?? const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  property.photos.isNotEmpty ? property.photos.first : 'https://via.placeholder.com/600x400',
                  height: isCompact ? 100 : 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: isCompact ? 100 : 220,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              if (property.isVerified)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: AppTypography.labelMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Details Section
          Padding(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: isCompact ? AppTypography.titleMedium : AppTypography.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isCompact ? 4 : 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: isCompact ? 12 : 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.city,
                        style: isCompact ? AppTypography.bodySmall : AppTypography.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isCompact ? 8 : 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: isCompact ? 8 : 16,
                        runSpacing: 4,
                        children: [
                          _buildAmenity(Icons.bed_outlined, '${property.bedrooms}', isCompact),
                          _buildAmenity(Icons.bathtub_outlined, '${property.bathrooms}', isCompact),
                          _buildAmenity(Icons.square_foot_outlined, '${property.area.toInt()} sqft', isCompact),
                        ],
                      ),
                    ),
                    Text(
                      '\$${property.price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}',
                      style: isCompact 
                        ? AppTypography.titleMini.copyWith(color: AppColors.primary)
                        : AppTypography.titleSmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                SizedBox(height: isCompact ? 12 : 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: isCompact ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'View Details',
                    style: (isCompact ? AppTypography.labelMedium : AppTypography.labelLarge).copyWith(color: Colors.white),
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
  }

  Widget _buildAmenity(IconData icon, String value, bool isCompact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isCompact ? 14 : 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          value,
          style: isCompact ? AppTypography.bodySmall : AppTypography.bodyMedium,
        ),
      ],
    );
  }
}
