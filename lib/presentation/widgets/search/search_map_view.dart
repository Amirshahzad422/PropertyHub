import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/providers/map_provider.dart';
import 'package:propertyhub/presentation/providers/places_provider.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/map/custom_map_view.dart';
import 'package:propertyhub/presentation/widgets/map/map_carousel.dart';
import 'package:propertyhub/presentation/widgets/search/nearby_places_bottom_sheet.dart';

class SearchMapView extends ConsumerWidget {
  final List<PropertyModel> properties;

  const SearchMapView({
    super.key,
    required this.properties,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraPosition = ref.watch(mapCameraPositionProvider);
    final selectedProperty = ref.watch(selectedMapPropertyProvider);
    final searchQuery = ref.watch(propertyFilterProvider).query ?? '';

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
            searchQuery: searchQuery,
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
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => NearbyPlacesBottomSheet(places: places),
        );
      },
      error: (err, stack) {},
    );
  }
}
