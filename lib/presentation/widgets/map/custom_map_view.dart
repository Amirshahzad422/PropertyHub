import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/core/utils/map_marker_generator.dart';

class CustomMapView extends StatefulWidget {
  final List<PropertyModel> properties;
  final Function(PropertyModel) onMarkerTap;
  final CameraPosition initialCameraPosition;

  const CustomMapView({
    super.key,
    required this.properties,
    required this.onMarkerTap,
    required this.initialCameraPosition,
  });

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(CustomMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.properties != widget.properties) {
      _buildMarkers();
    }
  }

  Future<void> _buildMarkers() async {
    final markers = <Marker>{};

    for (final property in widget.properties) {
      final formattedPrice = MapMarkerGenerator.formatPrice(property.price);
      final customIcon = await MapMarkerGenerator.createPriceMarker(formattedPrice);
      
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.location.latitude, property.location.longitude),
        icon: customIcon,
        onTap: () => widget.onMarkerTap(property),
      );
      markers.add(marker);
    }

    if (mounted) {
      setState(() => _markers = markers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: widget.initialCameraPosition,
      markers: _markers,
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: false,
    );
  }
}