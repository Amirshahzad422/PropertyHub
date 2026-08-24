import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final String ownerId;
  final String title;
  final String category;
  final String propertyType;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String city;
  final String description;
  final String? yearBuilt;
  final String? furnishing;
  final List<String> amenities;
  final List<String> photos;
  final String? floorPlanUrl;
  final String? panorama360Url;
  final GeoPoint location;
  final String geohash;
  final bool isVerified;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.category,
    required this.propertyType,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.city,
    required this.description,
    this.yearBuilt,
    this.furnishing,
    required this.amenities,
    required this.photos,
    this.floorPlanUrl,
    this.panorama360Url,
    required this.location,
    required this.geohash,
    this.isVerified = false,
    this.viewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PropertyModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? 'sale',
      propertyType: data['propertyType'] ?? 'apartment',
      price: (data['price'] ?? 0).toDouble(),
      bedrooms: data['bedrooms'] ?? 0,
      bathrooms: data['bathrooms'] ?? 0,
      area: (data['area'] ?? 0).toDouble(),
      city: data['city'] ?? '',
      description: data['description'] ?? '',
      yearBuilt: data['yearBuilt'],
      furnishing: data['furnishing'],
      amenities: List<String>.from(data['amenities'] ?? []),
      photos: List<String>.from(data['photos'] ?? []),
      floorPlanUrl: data['floorPlanUrl'],
      panorama360Url: data['panorama360Url'],
      location: data['location'] as GeoPoint,
      geohash: data['geohash'] ?? '',
      isVerified: data['isVerified'] ?? false,
      viewsCount: data['viewsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'title': title,
      'category': category,
      'propertyType': propertyType,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'city': city,
      'description': description,
      if (yearBuilt != null) 'yearBuilt': yearBuilt,
      if (furnishing != null) 'furnishing': furnishing,
      'amenities': amenities,
      'photos': photos,
      if (floorPlanUrl != null) 'floorPlanUrl': floorPlanUrl,
      if (panorama360Url != null) 'panorama360Url': panorama360Url,
      'location': location,
      'geohash': geohash,
      'isVerified': isVerified,
      'viewsCount': viewsCount,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  PropertyModel copyWith({
    String? title,
    double? price,
    int? bedrooms,
    int? bathrooms,
    double? area,
    String? city,
    String? description,
    String? furnishing,
    List<String>? amenities,
    List<String>? photos,
    String? floorPlanUrl,
    String? panorama360Url,
    GeoPoint? location,
    String? geohash,
    bool? isVerified,
    int? viewsCount,
  }) {
    return PropertyModel(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      category: category,
      propertyType: propertyType,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      city: city ?? this.city,
      description: description ?? this.description,
      yearBuilt: yearBuilt,
      furnishing: furnishing ?? this.furnishing,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      floorPlanUrl: floorPlanUrl ?? this.floorPlanUrl,
      panorama360Url: panorama360Url ?? this.panorama360Url,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      isVerified: isVerified ?? this.isVerified,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
