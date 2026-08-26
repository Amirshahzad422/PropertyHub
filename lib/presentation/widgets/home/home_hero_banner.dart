import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/widgets/common/custom_search_bar.dart';

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'FEATURED ESTATE',
                    style: AppTypography.labelMedium.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The Glass Pavilion',
                  style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Beverly Hills, California',
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 24,
            left: 24,
            right: 24,
            child: CustomSearchBar(
              readOnly: true,
              onTap: () => context.go('/search'),
            ),
          ),
        ],
      ),
    );
  }
}
