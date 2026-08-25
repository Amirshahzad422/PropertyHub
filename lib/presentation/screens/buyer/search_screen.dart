import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/common/custom_search_bar.dart';
import 'package:propertyhub/presentation/widgets/common/filter_bottom_sheet.dart';
import 'package:propertyhub/presentation/widgets/common/loader_skeleton.dart';
import 'package:propertyhub/presentation/widgets/property/property_card.dart';
import 'package:propertyhub/presentation/widgets/property/grid_property_card.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/providers/map_provider.dart';
import 'package:propertyhub/presentation/widgets/map/custom_map_view.dart';
import 'package:propertyhub/presentation/widgets/map/map_carousel.dart';

final viewModeProvider = StateProvider.autoDispose<int>((ref) => 0);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchPropertiesProvider);
    final viewMode = ref.watch(viewModeProvider);
    final currentFilter = ref.watch(propertyFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomSearchBar(
                readOnly: false,
                hintText: 'Search by location, building, or ...',
                onChanged: (value) {
                  ref.read(propertyFilterProvider.notifier).state = 
                      currentFilter.copyWith(query: value, clearQuery: value.isEmpty);
                },
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FilterBottomSheet(
                      initialFilter: currentFilter,
                      onApply: (newFilter) {
                        ref.read(propertyFilterProvider.notifier).state = newFilter;
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildViewToggle(context, ref, viewMode),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: searchAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildContent(viewMode, properties, ref, context);
                },
                loading: () => _buildLoadingState(viewMode),
                error: (err, stack) => _buildErrorState(ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context, WidgetRef ref, int viewMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleBtn(0, Icons.view_list_rounded, viewMode, ref)),
          Expanded(child: _buildToggleBtn(1, Icons.grid_view_rounded, viewMode, ref)),
          Expanded(child: _buildToggleBtn(2, Icons.map_rounded, viewMode, ref)),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(int index, IconData icon, int viewMode, WidgetRef ref) {
    final isSelected = viewMode == index;
    return GestureDetector(
      onTap: () {
        ref.read(viewModeProvider.notifier).state = index;
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: AppTypography.titleMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search query',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(int viewMode) {
    if (viewMode == 0) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: 3,
        itemBuilder: (context, index) => const PropertyCardSkeleton(),
      );
    } else if (viewMode == 1) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const GridPropertyCardSkeleton(),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text('Failed to search properties', style: AppTypography.bodyLarge),
          TextButton(
            onPressed: () => ref.refresh(searchPropertiesProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(int viewMode, List<PropertyModel> properties, WidgetRef ref, BuildContext context) {
    if (viewMode == 0) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return PropertyCard(
            property: properties[index],
            onFavoriteTap: () {},
          );
        },
      );
    } else if (viewMode == 1) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return GridPropertyCard(
            property: properties[index],
            onFavoriteTap: () {},
          );
        },
      );
    } else {
      return _buildMapView(properties, ref, context);
    }
  }

  Widget _buildMapView(List<PropertyModel> properties, WidgetRef ref, BuildContext context) {
    final cameraPosition = ref.watch(mapCameraPositionProvider);
    final selectedProperty = ref.watch(selectedMapPropertyProvider);

    return Stack(
      children: [
        CustomMapView(
          properties: properties,
          initialCameraPosition: cameraPosition,
          onMarkerTap: (property) {
            ref.read(selectedMapPropertyProvider.notifier).state = property;
            _showNeighbourhoodInsights(property, ref, context);
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MapCarousel(
            properties: properties,
            selectedProperty: selectedProperty,
            searchQuery: ref.watch(propertyFilterProvider).query ?? '',
          ),
        ),
      ],
    );
  }

  void _showNeighbourhoodInsights(PropertyModel property, WidgetRef ref, BuildContext context) {
    final placesAsync = ref.refresh(nearbyPlacesProvider(property.id));

    placesAsync.whenOrNull(
      data: (places) {
        if (places.isEmpty) return;
        if (!context.mounted) return;
        _showNearbyPlacesBottomSheet(places, context);
      },
      error: (err, stack) {},
    );
  }

  void _showNearbyPlacesBottomSheet(List<Map<String, dynamic>> places, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
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
                        _getIconForType(place['type']),
                        color: AppColors.primary,
                      ),
                      title: Text(place['name'] ?? 'Unknown'),
                      subtitle: Text(place['vicinity'] ?? ''),
                      trailing: Text(
                        place['rating'] != 0.0 ? '⭐ ${place['rating'].toStringAsFixed(1)}' : '',
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
      },
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