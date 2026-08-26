import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propertyhub/data/models/place_model.dart';

class PlacesApiService {
  final String apiKey;

  PlacesApiService({required this.apiKey});

  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 1500,
    List<String> types = const ['school', 'hospital', 'restaurant', 'transit_station'],
  }) async {
    final results = <PlaceModel>[];

    for (final type in types) {
      try {
        final url = '$_baseUrl?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey';
        final response = await http.get(
          Uri.parse(url),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
            final places = data['results'] as List<dynamic>? ?? [];
            int categoryCount = 0;
            for (final place in places) {
              if (categoryCount >= 3) break; // Limit to 3 places per category to ensure a mix
              
              if (place['types']?.contains(type) == true) {
                results.add(PlaceModel(
                  name: place['name'] ?? 'Unknown',
                  vicinity: place['vicinity'] ?? '',
                  type: type,
                  rating: (place['rating'] ?? 0.0).toDouble(),
                  icon: place['icon'] ?? '',
                ));
                categoryCount++;
              }
            }
          } else {
            // Handle error silently or log
          }
        }
      } catch (e) {
        // Handle exception silently or log
      }
    }

    final seen = <String>{};
    final uniqueResults = results.where((place) {
      final key = place.name + place.type;
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();

    return uniqueResults.take(10).toList();
  }
}


