import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_model.dart';

class PropertyKeyFeatures extends StatelessWidget {
  final PropertyModel property;

  const PropertyKeyFeatures({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildFeatureCard(Icons.bed_outlined, '${property.bedrooms}', 'BEDROOMS')),
        const SizedBox(width: 12),
        Expanded(child: _buildFeatureCard(Icons.bathtub_outlined, '${property.bathrooms}', 'BATHROOMS')),
        const SizedBox(width: 12),
        Expanded(child: _buildFeatureCard(Icons.square_foot_outlined, '${property.area.toInt()}', 'SQUARE FEET')),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.charcoalText),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.charcoalText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
