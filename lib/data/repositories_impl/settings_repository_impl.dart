import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propertyhub/data/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final FirebaseFirestore _firestore;

  SettingsRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<String> getGoogleMapsApiKey() async {
    try {
      final doc = await _firestore.collection('appSettings').doc('googlemaps').get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['apiKey'] as String? ?? '';
      }
      return '';
    } catch (e) {
      throw Exception('Failed to get Google Maps API key: $e');
    }
  }
}
