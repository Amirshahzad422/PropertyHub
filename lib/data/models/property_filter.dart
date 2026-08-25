class PropertyFilter {
  final String? category;
  final String? propertyType;
  final double? minPrice;
  final double? maxPrice;
  final int? bedrooms;
  final int? bathrooms;
  final double? minArea;
  final double? maxArea;
  final String? city;
  final String? furnishing;
  final List<String> amenities;
  final bool? isVerified;

  final String? query;

  PropertyFilter({
    this.category,
    this.propertyType,
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.bathrooms,
    this.minArea,
    this.maxArea,
    this.city,
    this.furnishing,
    this.amenities = const [],
    this.isVerified,
    this.query,
  });

  PropertyFilter copyWith({
    String? category,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int? bathrooms,
    double? minArea,
    double? maxArea,
    String? city,
    String? furnishing,
    List<String>? amenities,
    bool? isVerified,
    String? query,
    bool clearCategory = false,
    bool clearPropertyType = false,
    bool clearBedrooms = false,
    bool clearBathrooms = false,
    bool clearCity = false,
    bool clearFurnishing = false,
    bool clearIsVerified = false,
    bool clearQuery = false,
  }) {
    return PropertyFilter(
      category: clearCategory ? null : (category ?? this.category),
      propertyType: clearPropertyType ? null : (propertyType ?? this.propertyType),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      bedrooms: clearBedrooms ? null : (bedrooms ?? this.bedrooms),
      bathrooms: clearBathrooms ? null : (bathrooms ?? this.bathrooms),
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      city: clearCity ? null : (city ?? this.city),
      furnishing: clearFurnishing ? null : (furnishing ?? this.furnishing),
      amenities: amenities ?? this.amenities,
      isVerified: clearIsVerified ? null : (isVerified ?? this.isVerified),
      query: clearQuery ? null : (query ?? this.query),
    );
  }

  bool get isEmpty =>
      category == null &&
      propertyType == null &&
      minPrice == null &&
      maxPrice == null &&
      bedrooms == null &&
      bathrooms == null &&
      minArea == null &&
      maxArea == null &&
      city == null &&
      furnishing == null &&
      amenities.isEmpty &&
      isVerified == null &&
      query == null;
}
