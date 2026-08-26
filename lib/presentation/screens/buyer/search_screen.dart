import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/common/custom_search_bar.dart';
import 'package:propertyhub/presentation/widgets/common/filter_bottom_sheet.dart';
import 'package:propertyhub/presentation/widgets/property/property_card.dart';
import 'package:propertyhub/presentation/widgets/property/grid_property_card.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/widgets/search/search_view_toggle.dart';
import 'package:propertyhub/presentation/widgets/search/search_empty_state.dart';
import 'package:propertyhub/presentation/widgets/search/search_loading_state.dart';
import 'package:propertyhub/presentation/widgets/search/search_error_state.dart';
import 'package:propertyhub/presentation/widgets/search/search_map_view.dart';

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SearchViewToggle(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: searchAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return const SearchEmptyState();
                  }
                  return _buildContent(viewMode, properties);
                },
                loading: () => const SearchLoadingState(),
                error: (err, stack) => const SearchErrorState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(int viewMode, List<PropertyModel> properties) {
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
      return SearchMapView(properties: properties);
    }
  }
}