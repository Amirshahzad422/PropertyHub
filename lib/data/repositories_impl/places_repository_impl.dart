import 'package:propertyhub/data/datasources/places_api_service.dart';
import 'package:propertyhub/data/models/place_model.dart';
import 'package:propertyhub/data/repositories/places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesApiService _placesApiService;

  PlacesRepositoryImpl({required PlacesApiService placesApiService})
      : _placesApiService = placesApiService;

  @override
  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 1500,
    List<String> types = const ['school', 'hospital', 'restaurant', 'transit_station'],
  }) async {
    return _placesApiService.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      types: types,
    );
  }
}
