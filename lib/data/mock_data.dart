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
      String? panorama360Url,
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
        panorama360Url: panorama360Url,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    properties.addAll([
      // LHAORE - GULBERG CLUSTER
      createProperty(
        id: '1', ownerId: 'o1',
        title: 'Gulberg Plaza', category: 'commercial', propertyType: 'commercial',
        price: 45000000, bedrooms: 0, bathrooms: 2, area: 1200, city: 'Lahore, Punjab',
        description: 'Prime commercial space in Gulberg.',
        amenities: ['Parking', 'Security'],
        photos: [
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab',
          'https://images.unsplash.com/photo-1577495508048-b635879837f1',
          'https://images.unsplash.com/photo-1554469384-e58fac16e23a'
        ],
        location: const GeoPoint(31.5100, 74.3400), isVerified: true, viewsCount: 120,
        panorama360Url: 'https://pannellum.org/images/alma.jpg',
      ),
      createProperty(
        id: '2', ownerId: 'o2',
        title: 'Modern Apartment MM Alam', category: 'sale', propertyType: 'apartment',
        price: 18000000, bedrooms: 3, bathrooms: 3, area: 2200, city: 'Lahore, Punjab',
        description: 'Luxury living on MM Alam road.',
        amenities: ['Gym', 'Pool'],
        photos: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00',
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750'
        ],
        location: const GeoPoint(31.5120, 74.3420), isVerified: true, viewsCount: 45,
        panorama360Url: 'https://pannellum.org/images/alma.jpg',
      ),
      createProperty(
        id: '3', ownerId: 'o3',
        title: 'Cozy Studio', category: 'rent', propertyType: 'apartment',
        price: 65000, bedrooms: 1, bathrooms: 1, area: 800, city: 'Lahore, Punjab',
        description: 'Perfect for bachelors.',
        amenities: ['Furnished'],
        photos: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267'],
        location: const GeoPoint(31.5150, 74.3450), isVerified: false, viewsCount: 15,
        panorama360Url: 'https://pannellum.org/images/alma.jpg',
      ),
      // LAHORE - DHA CLUSTER
      createProperty(
        id: '4', ownerId: 'o1',
        title: 'DHA Phase 5 Villa', category: 'sale', propertyType: 'villa',
        price: 85000000, bedrooms: 5, bathrooms: 6, area: 4500, city: 'Lahore, Punjab',
        description: 'A massive 1 Kanal villa.',
        amenities: ['Garden', 'Servant Quarter'],
        photos: ['https://images.unsplash.com/photo-1600596542815-ffad4c1539a9'],
        location: const GeoPoint(31.4700, 74.4000), isVerified: true, viewsCount: 300,
      ),
      createProperty(
        id: '5', ownerId: 'o2',
        title: 'DHA Commercial', category: 'commercial', propertyType: 'commercial',
        price: 120000000, bedrooms: 0, bathrooms: 4, area: 3000, city: 'Lahore, Punjab',
        description: 'Brand new plaza in DHA.',
        amenities: ['Elevator'],
        photos: ['https://images.unsplash.com/photo-1560518883-ce09059eeffa'],
        location: const GeoPoint(31.4720, 74.4020), isVerified: true, viewsCount: 88,
      ),

      // KARACHI - CLIFTON CLUSTER
      createProperty(
        id: '6', ownerId: 'o3',
        title: 'Clifton Beach View', category: 'rent', propertyType: 'apartment',
        price: 250000, bedrooms: 4, bathrooms: 4, area: 3500, city: 'Karachi, Sindh',
        description: 'Sea facing luxury apartment.',
        amenities: ['Sea View', 'Gym'],
        photos: ['https://images.unsplash.com/photo-1512917774080-9991f1c4c750'],
        location: const GeoPoint(24.8100, 67.0100), isVerified: true, viewsCount: 220,
      ),
      createProperty(
        id: '7', ownerId: 'o4',
        title: 'Clifton Block 2 Studio', category: 'rent', propertyType: 'apartment',
        price: 45000, bedrooms: 1, bathrooms: 1, area: 600, city: 'Karachi, Sindh',
        description: 'Affordable studio.',
        amenities: [],
        photos: ['https://images.unsplash.com/photo-1536376072261-38c75010e6c9'],
        location: const GeoPoint(24.8150, 67.0150), isVerified: false, viewsCount: 12,
      ),

      // KARACHI - DHA CLUSTER
      createProperty(
        id: '8', ownerId: 'o1',
        title: 'DHA Karachi Mansion', category: 'sale', propertyType: 'villa',
        price: 150000000, bedrooms: 6, bathrooms: 7, area: 8000, city: 'Karachi, Sindh',
        description: 'Huge mansion in DHA Phase 8.',
        amenities: ['Pool', 'Garden', 'Smart Home'],
        photos: ['https://images.unsplash.com/photo-1600585154340-be6161a56a0c'],
        location: const GeoPoint(24.7900, 67.0500), isVerified: true, viewsCount: 500,
      ),
      createProperty(
        id: '9', ownerId: 'o2',
        title: 'Bungalow DHA', category: 'sale', propertyType: 'villa',
        price: 90000000, bedrooms: 4, bathrooms: 5, area: 4000, city: 'Karachi, Sindh',
        description: 'Beautiful bungalow.',
        amenities: ['Garden'],
        photos: ['https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83'],
        location: const GeoPoint(24.7920, 67.0520), isVerified: true, viewsCount: 110,
      ),

      // ISLAMABAD CLUSTER
      createProperty(
        id: '10', ownerId: 'o5',
        title: 'Blue Area Office', category: 'rent', propertyType: 'commercial',
        price: 500000, bedrooms: 0, bathrooms: 2, area: 2000, city: 'Islamabad, ICT',
        description: 'Spacious office space.',
        amenities: ['Parking', 'Security'],
        photos: ['https://images.unsplash.com/photo-1497366216548-37526070297c'],
        location: const GeoPoint(33.7100, 73.0600), isVerified: true, viewsCount: 75,
      ),
      createProperty(
        id: '11', ownerId: 'o6',
        title: 'F-8 House', category: 'sale', propertyType: 'villa',
        price: 110000000, bedrooms: 5, bathrooms: 5, area: 5500, city: 'Islamabad, ICT',
        description: 'Luxury house in F-8.',
        amenities: ['Garden', 'Heating'],
        photos: ['https://images.unsplash.com/photo-1600607687920-4e2a09cf159d'],
        location: const GeoPoint(33.7150, 73.0650), isVerified: false, viewsCount: 180,
      ),
      createProperty(
        id: '12', ownerId: 'o7',
        title: 'Centaurus Apartment', category: 'rent', propertyType: 'apartment',
        price: 180000, bedrooms: 2, bathrooms: 2, area: 1500, city: 'Islamabad, ICT',
        description: 'High end apartment with city views.',
        amenities: ['Gym', 'Mall Access'],
        photos: ['https://images.unsplash.com/photo-1502672260266-1c1de2d966ce'],
        location: const GeoPoint(33.7080, 73.0550), isVerified: true, viewsCount: 300,
      ),
    ]);

    return properties;
  }

  static List<PropertyModel> get properties => _generateProperties();
}
