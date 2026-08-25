import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/common/category_chip.dart';
import 'package:propertyhub/presentation/widgets/common/custom_search_bar.dart';
import 'package:propertyhub/presentation/widgets/common/loader_skeleton.dart';
import 'package:propertyhub/presentation/widgets/property/property_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(homeCategoryProvider);
    final propertiesAsync = ref.watch(homePropertiesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
          ),
          
          const SizedBox(height: 24),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ref.read(homeCategoryProvider.notifier).state = 'For Sale',
                  child: CategoryChip(label: 'For Sale', isSelected: selectedCategory == 'For Sale'),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => ref.read(homeCategoryProvider.notifier).state = 'For Rent',
                  child: CategoryChip(label: 'For Rent', isSelected: selectedCategory == 'For Rent'),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => ref.read(homeCategoryProvider.notifier).state = 'Commercial',
                  child: CategoryChip(label: 'Commercial', isSelected: selectedCategory == 'Commercial'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
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
          
          const SizedBox(height: 48), 
        ],
      ),
    );
  }
}
