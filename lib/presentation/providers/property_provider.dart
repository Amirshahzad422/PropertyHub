import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/data/models/property_filter.dart';
import 'package:propertyhub/data/repositories/property_repository.dart';
import 'package:propertyhub/data/repositories_impl/property_repository_impl.dart';

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepositoryImpl();
});

final featuredPropertiesProvider = FutureProvider<List<PropertyModel>>((ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getFeaturedProperties();
});

final homeCategoryProvider = StateProvider<String>((ref) => 'For Sale');

final homePropertiesProvider = FutureProvider<List<PropertyModel>>((ref) async {
  final category = ref.watch(homeCategoryProvider);
  final repo = ref.watch(propertyRepositoryProvider);
  
  // Use searchProperties to filter by category
  final filter = PropertyFilter(category: category);
  final properties = await repo.searchProperties(filter);
  
  // Fallback if empty
  if (properties.isEmpty) {
    return repo.getFeaturedProperties();
  }
  
  return properties;
});

final propertyDetailsProvider = FutureProvider.family<PropertyModel?, String>((ref, id) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getPropertyById(id);
});

final propertyFilterProvider = StateProvider<PropertyFilter>((ref) {
  return PropertyFilter();
});

final searchPropertiesProvider = FutureProvider<List<PropertyModel>>((ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  final filter = ref.watch(propertyFilterProvider);
  return repo.searchProperties(filter);
});
