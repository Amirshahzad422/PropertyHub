import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_model.dart';

class PropertyOwnerInfo extends StatelessWidget {
  final PropertyModel property;

  const PropertyOwnerInfo({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Agent',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.charcoalText,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150&q=80'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eleanor Vance',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.charcoalText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Senior Partner, Luxury Division',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: const Text('Schedule Visit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('Chat with Owner'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
