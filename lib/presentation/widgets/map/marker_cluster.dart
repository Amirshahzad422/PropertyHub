import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propertyhub/data/models/property_model.dart';

class ManualClusterEngine {
  static const double defaultThreshold = 0.01;

  static List<PropertyCluster> cluster({
    required List<PropertyModel> properties,
    required double zoom,
    double threshold = defaultThreshold,
  }) {
    if (properties.isEmpty) return [];

    if (zoom >= 16) {
      return properties.map((p) => PropertyCluster.single(p)).toList();
    }

    final adjustedThreshold = _getAdjustedThreshold(zoom);

    final clusters = <PropertyCluster>[];
    final processed = <String>{};

    for (final property in properties) {
      if (processed.contains(property.id)) continue;

      final clusterMembers = <PropertyModel>[property];
      processed.add(property.id);

      for (final other in properties) {
        if (processed.contains(other.id)) continue;

        final distance = _haversineDistance(
          property.location.latitude,
          property.location.longitude,
          other.location.latitude,
          other.location.longitude,
        );

        if (distance < adjustedThreshold) {
          clusterMembers.add(other);
          processed.add(other.id);
        }
      }

      if (clusterMembers.length == 1) {
        clusters.add(PropertyCluster.single(clusterMembers.first));
      } else {
        clusters.add(PropertyCluster.cluster(clusterMembers));
      }
    }

    return clusters;
  }

  static double _getAdjustedThreshold(double zoom) {
    // Return distance in km based on zoom level.
    // Lower zoom = larger threshold (cluster properties from further away)
    if (zoom <= 10) return 20.0; // 20 km
    if (zoom <= 12) return 10.0; // 10 km
    if (zoom <= 14) return 5.0;  // 5 km
    if (zoom <= 15) return 2.0;  // 2 km
    if (zoom <= 16) return 0.5;  // 500 meters
    return 0.1; // 100 meters
  }

  static double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; 
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // km
  }

  static double _toRadians(double degree) => degree * pi / 180;
}

class PropertyCluster {
  final String id;
  final LatLng position;
  final List<PropertyModel> properties;
  final bool isCluster;

  PropertyCluster({
    required this.id,
    required this.position,
    required this.properties,
    this.isCluster = false,
  });

  factory PropertyCluster.single(PropertyModel property) {
    return PropertyCluster(
      id: property.id,
      position: LatLng(property.location.latitude, property.location.longitude),
      properties: [property],
      isCluster: false,
    );
  }

  factory PropertyCluster.cluster(List<PropertyModel> properties) {
    final avgLat = properties.map((p) => p.location.latitude).reduce((a, b) => a + b) / properties.length;
    final avgLng = properties.map((p) => p.location.longitude).reduce((a, b) => a + b) / properties.length;

    return PropertyCluster(
      id: 'cluster_${properties.map((p) => p.id).join('_')}',
      position: LatLng(avgLat, avgLng),
      properties: properties,
      isCluster: true,
    );
  }

  int get count => properties.length;
}
