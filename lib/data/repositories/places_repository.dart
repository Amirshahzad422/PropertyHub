
import 'package:propertyhub/data/models/place_model.dart';

abstract class PlacesRepository {
  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 1500,
    List<String> types = const ['school', 'hospital', 'restaurant', 'transit_station'],
  });
}
