import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/data/datasources/places_api_service.dart';
import 'package:propertyhub/data/models/place_model.dart';
import 'package:propertyhub/data/repositories/places_repository.dart';
import 'package:propertyhub/data/repositories_impl/places_repository_impl.dart';
import 'package:propertyhub/presentation/providers/map_provider.dart';


final placesApiKeyProvider = FutureProvider<String>((ref) async {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return settingsRepo.getGoogleMapsApiKey();
});

final placesRepositoryProvider = FutureProvider<PlacesRepository>((ref) async {
  final apiKey = await ref.watch(placesApiKeyProvider.future);
  final service = PlacesApiService(apiKey: apiKey);
  return PlacesRepositoryImpl(placesApiService: service);
});

final nearbyPlacesProvider = FutureProvider.family<List<PlaceModel>, String>((ref, propertyId) async {
  final repo = await ref.watch(placesRepositoryProvider.future);
  
  final properties = ref.watch(mapMarkersProvider);
  final property = properties.firstWhere(
    (p) => p.id == propertyId,
    orElse: () => throw Exception('Property not found'),
  );

  return repo.getNearbyPlaces(
    latitude: property.location.latitude,
    longitude: property.location.longitude,
  );
});
