import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/data/models/property_filter.dart';

abstract class PropertyRepository {
  Future<List<PropertyModel>> getFeaturedProperties();
  Future<List<PropertyModel>> getRecommendedProperties(String userId);
  Future<List<PropertyModel>> searchProperties(PropertyFilter filter);
  Future<PropertyModel?> getPropertyById(String id);
  Future<void> toggleWishlist(String propertyId, String userId);
  Future<List<PropertyModel>> getWishlist(String userId);
}
