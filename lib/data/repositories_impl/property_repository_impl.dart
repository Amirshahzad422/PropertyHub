import 'package:propertyhub/data/mock_data.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/data/models/property_filter.dart';
import 'package:propertyhub/data/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  @override
  Future<List<PropertyModel>> getFeaturedProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Return a subset as featured
    return MockData.properties.take(5).toList();
  }

  @override
  Future<List<PropertyModel>> getRecommendedProperties(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Ignore userId for now and return some recommended properties
    return MockData.properties.skip(5).take(5).toList();
  }

  @override
  Future<List<PropertyModel>> searchProperties(PropertyFilter filter) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.properties.where((prop) {
      if (filter.query != null && filter.query!.isNotEmpty) {
        final query = filter.query!.toLowerCase();
        if (!prop.title.toLowerCase().contains(query) &&
            !prop.city.toLowerCase().contains(query)) {
          return false;
        }
      }
      if (filter.category != null && prop.category != filter.category) return false;
      if (filter.propertyType != null && prop.propertyType != filter.propertyType) return false;
      if (filter.minPrice != null && prop.price < filter.minPrice!) return false;
      if (filter.maxPrice != null && prop.price > filter.maxPrice!) return false;
      if (filter.bedrooms != null && prop.bedrooms < filter.bedrooms!) return false;
      if (filter.bathrooms != null && prop.bathrooms < filter.bathrooms!) return false;
      return true;
    }).toList();
  }

  @override
  Future<PropertyModel?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return MockData.properties.firstWhere((prop) => prop.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> toggleWishlist(String propertyId, String userId) async {
    // Mock implementation, do nothing
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<List<PropertyModel>> getWishlist(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return a few properties as wishlist for now
    return MockData.properties.take(2).toList();
  }
}
