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
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildViewToggle(context, ref, viewMode),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
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
                      icon: const Icon(Icons.tune, color: Colors.white, size: 18),
                      label: Text(
                        'Filters',
                        style: AppTypography.labelLarge.copyWith(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: searchAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildPropertyList(viewMode, properties, ref);
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
          _buildToggleBtn(0, Icons.view_list_rounded, viewMode, ref),
          _buildToggleBtn(1, Icons.grid_view_rounded, viewMode, ref),
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
    } else {
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

  Widget _buildPropertyList(int viewMode, List properties, WidgetRef ref) {
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
    } else {
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
    }
  }
}