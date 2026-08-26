import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_model.dart';

class PropertyDescription extends StatelessWidget {
  final PropertyModel property;

  const PropertyDescription({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this property',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.charcoalText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          property.description.isEmpty 
              ? 'A masterclass in modern architecture, this property offers an unparalleled living experience. Blending organic materials with cutting-edge technology, it is designed for those who appreciate luxury.'
              : property.description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
