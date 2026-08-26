import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=200&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Alexander Knight',
          style: TextStyle(
            fontFamily: AppTypography.serifFont,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalText,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Premium Member',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grayText,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.grey.shade600,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Member since October 2021',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
