import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesApiService {
  final String apiKey;

  PlacesApiService({required this.apiKey});

  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  Future<List<Map<String, dynamic>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 1000,
    List<String> types = const ['school', 'hospital', 'restaurant', 'transit_station'],
  }) async {
    final results = <Map<String, dynamic>>[];

    for (final type in types) {
      try {
        final response = await http.get(
          Uri.parse(
            '$_baseUrl?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey',
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
            final places = data['results'] as List<dynamic>? ?? [];
            for (final place in places) {
              if (place['types']?.contains(type) == true) {
                results.add({
                  'name': place['name'] ?? 'Unknown',
                  'vicinity': place['vicinity'] ?? '',
                  'type': type,
                  'icon': place['icon'] ?? '',
                  'rating': place['rating'] ?? 0.0,
                  'user_ratings_total': place['user_ratings_total'] ?? 0,
                });
              }
            }
          }
        }
      } catch (_) {
      }
    }

    return results.take(10).toList();
  }
}
