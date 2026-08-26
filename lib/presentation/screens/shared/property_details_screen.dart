import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/property/neighbourhood_insights.dart';
import 'package:propertyhub/presentation/widgets/property/verified_badge.dart';
import 'package:propertyhub/presentation/widgets/property/just_listed_badge.dart';
import 'package:propertyhub/presentation/widgets/property/property_image_gallery.dart';
import 'package:propertyhub/presentation/widgets/property/property_key_features.dart';
import 'package:propertyhub/presentation/widgets/property/property_description.dart';
import 'package:propertyhub/presentation/widgets/property/property_owner_info.dart';
import 'package:propertyhub/presentation/widgets/property/property_bottom_bar.dart';

class PropertyDetailsScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailsProvider(propertyId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: propertyAsync.when(
        loading: () => const _LoadingState(),
        error: (err, stack) => _ErrorState(
          onRetry: () => ref.refresh(propertyDetailsProvider(propertyId)),
        ),
        data: (property) {
          if (property == null) {
            return const _NotFoundState();
          }
          return _PropertyDetailsContent(property: property);
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load property details',
              style: AppTypography.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.house_outlined, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'Property not found',
              style: AppTypography.titleMedium.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyDetailsContent extends ConsumerWidget {
  final PropertyModel property;

  const _PropertyDetailsContent({required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.sizeOf(context).height * 0.45,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.charcoalText, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.charcoalText, size: 20),
                    onPressed: () {},
                  ),
                ),
              ),
              if (property.panorama360Url != null && property.panorama360Url!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.threesixty, color: AppColors.primary, size: 20),
                      onPressed: () {
                        context.push('/panorama/${property.id}');
                      },
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PropertyImageGallery(photos: property.photos),
                  
                  // if (property.panorama360Url != null && property.panorama360Url!.isNotEmpty)
                  //   Center(
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         context.push('/panorama/${property.id}');
                  //       },
                  //       child: Container(
                  //         padding: const EdgeInsets.all(16),
                  //         decoration: BoxDecoration(
                  //           color: Colors.black.withValues(alpha: 0.4),
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: const Icon(Icons.threesixty, color: Colors.white, size: 32),
                  //       ),
                  //     ),
                  //   ),

                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Row(
                      children: [
                        if (property.isVerified)
                          const VerifiedBadge(),
                        if (property.isVerified && property.isJustListed)
                          const SizedBox(width: 8),
                        if (property.isJustListed)
                          const JustListedBadge(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.charcoalText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.city, 
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    '\$${property.price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.secondaryContainer,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Divider(height: 1, color: AppColors.surfaceVariant),
                  const SizedBox(height: 24),

                  PropertyKeyFeatures(property: property),
                  const SizedBox(height: 32),

                  PropertyDescription(property: property),
                  const SizedBox(height: 32),

                  PropertyOwnerInfo(property: property),
                  const SizedBox(height: 32),

                  NeighbourhoodInsights(propertyId: property.id),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const PropertyBottomBar(),
    );
  }
}
