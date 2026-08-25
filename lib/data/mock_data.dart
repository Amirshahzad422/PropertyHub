import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:propertyhub/data/models/property_model.dart';

class MockData {
  static List<PropertyModel> _generateProperties() {
    final properties = <PropertyModel>[];

    // Helper to create property with geohash
    PropertyModel createProperty({
      required String id,
      required String ownerId,
      required String title,
      required String category,
      required String propertyType,
      required double price,
      required int bedrooms,
      required int bathrooms,
      required double area,
      required String city,
      required String description,
      required List<String> amenities,
      required List<String> photos,
      required GeoPoint location,
      bool isVerified = false,
      int viewsCount = 0,
    }) {
      final geohash = GeoFirePoint(location).geohash;
      return PropertyModel(
        id: id,
        ownerId: ownerId,
        title: title,
        category: category,
        propertyType: propertyType,
        price: price,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        area: area,
        city: city,
        description: description,
        amenities: amenities,
        photos: photos,
        location: location,
        geohash: geohash,
        isVerified: isVerified,
        viewsCount: viewsCount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    properties.addAll([
      createProperty(
        id: '1',
        ownerId: 'owner1',
        title: 'Luxury Penthouse Downtown',
        category: 'sale',
        propertyType: 'apartment',
        price: 4250000,
        bedrooms: 3,
        bathrooms: 3,
        area: 3200,
        city: 'Lahore, Punjab',
        description: 'A masterclass in modern architecture...',
        amenities: ['parking', 'gym', 'pool', 'security'],
        photos: ['https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=600&q=80'],
        location: const GeoPoint(31.5204, 74.3587),
        isVerified: true,
        viewsCount: 45,
      ),
      createProperty(
        id: '2',
        ownerId: 'owner2',
        title: 'Modern Villa with Garden',
        category: 'rent',
        propertyType: 'villa',
        price: 2100000,
        bedrooms: 4,
        bathrooms: 3,
        area: 2800,
        city: 'Karachi, Sindh',
        description: 'Spacious villa with lush green garden...',
        amenities: ['parking', 'garden', 'security'],
        photos: ['https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80'],
        location: const GeoPoint(24.8607, 67.0011),
        isVerified: false,
        viewsCount: 12,
      ),
      createProperty(
        id: '3',
        ownerId: 'owner3',
        title: 'Commercial Plaza',
        category: 'commercial',
        propertyType: 'commercial',
        price: 8500000,
        bedrooms: 0,
        bathrooms: 4,
        area: 5000,
        city: 'Islamabad, ICT',
        description: 'Prime location commercial plaza...',
        amenities: ['parking', 'elevator', 'security'],
        photos: ['https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=600&q=80'],
        location: const GeoPoint(33.6844, 73.0479),
        isVerified: true,
        viewsCount: 88,
      ),
      createProperty(
        id: '4',
        ownerId: 'owner1',
        title: 'The Glass Pavilion',
        category: 'sale',
        propertyType: 'villa',
        price: 12500000,
        bedrooms: 5,
        bathrooms: 6,
        area: 8500,
        city: 'Lahore, Punjab', // Changed to Lahore for clustering testing
        description: 'A stunning modern architectural masterpiece with panoramic views.',
        amenities: ['Pool', 'Home Theater', 'Smart Home', 'Wine Cellar'],
        photos: ['https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80'],
        location: const GeoPoint(31.5304, 74.3687), // Near Property 1
        isVerified: true,
        viewsCount: 150,
      ),
      createProperty(
        id: '5',
        ownerId: 'owner2',
        title: 'Skyline Penthouse',
        category: 'rent',
        propertyType: 'apartment',
        price: 15000,
        bedrooms: 3,
        bathrooms: 3,
        area: 3200,
        city: 'Karachi, Sindh',
        description: 'Ultra-luxury penthouse featuring floor-to-ceiling windows.',
        amenities: ['Gym', 'Doorman', 'Terrace', 'Concierge'],
        photos: ['https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=80'],
        location: const GeoPoint(24.8707, 67.0111), // Near property 2
        isVerified: true,
        viewsCount: 90,
      ),
    ]);

    return properties;
  }

  static List<PropertyModel> get properties => _generateProperties();
}
