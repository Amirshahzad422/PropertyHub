import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/core/utils/map_marker_generator.dart';
import 'package:propertyhub/presentation/widgets/map/marker_cluster.dart';

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
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  double _currentZoom = 10.0;

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
    if (widget.properties.isEmpty) {
      if (mounted) setState(() => _markers = {});
      return;
    }

    final clusters = ManualClusterEngine.cluster(
      properties: widget.properties,
      zoom: _currentZoom,
    );

    final markers = <Marker>{};

    for (final cluster in clusters) {
      final icon = await _getMarkerIcon(cluster);
      final marker = Marker(
        markerId: MarkerId(cluster.id),
        position: cluster.position,
        icon: icon,
        onTap: () {
          if (cluster.isCluster) {
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: cluster.position,
                  zoom: _currentZoom + 2,
                ),
              ),
            );
          } else {
            widget.onMarkerTap(cluster.properties.first);
          }
        },
      );
      markers.add(marker);
    }

    if (mounted) {
      setState(() => _markers = markers);
    }
  }

  Future<BitmapDescriptor> _getMarkerIcon(PropertyCluster cluster) async {
    if (cluster.isCluster) {
      final double totalAmount = cluster.properties
          .fold(0.0, (sum, property) => sum + property.price);
      final String formattedAmount = MapMarkerGenerator.formatPrice(totalAmount);
      
      return await MapMarkerGenerator.createClusterMarker(
        text: formattedAmount,
      );
    } else {
      final property = cluster.properties.first;
      final formattedPrice = MapMarkerGenerator.formatPrice(property.price);
      return await MapMarkerGenerator.createPriceMarker(
        formattedPrice,
        isVerified: property.isVerified,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: widget.initialCameraPosition,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onCameraMove: (position) {
            _currentZoom = position.zoom;
          },
          onCameraIdle: () {
            _buildMarkers();
          },
          markers: _markers,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false, // Default disabled, using custom
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: false,
        ),
        // Custom Zoom Controls at Top Right
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildZoomButton(
                icon: Icons.add,
                onPressed: () {
                  _mapController.animateCamera(CameraUpdate.zoomIn());
                },
                isTop: true,
              ),
              Container(height: 1, width: 36, color: Colors.grey.shade300),
              _buildZoomButton(
                icon: Icons.remove,
                onPressed: () {
                  _mapController.animateCamera(CameraUpdate.zoomOut());
                },
                isTop: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isTop,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: isTop
          ? const BorderRadius.vertical(top: Radius.circular(8))
          : const BorderRadius.vertical(bottom: Radius.circular(8)),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: isTop
            ? const BorderRadius.vertical(top: Radius.circular(8))
            : const BorderRadius.vertical(bottom: Radius.circular(8)),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}