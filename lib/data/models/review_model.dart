import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String propertyId;
  final String reviewerId;
  final double rating;
  final List<String> tags;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.propertyId,
    required this.reviewerId,
    required this.rating,
    required this.tags,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ReviewModel(
      id: doc.id,
      propertyId: data['propertyId'] ?? '',
      reviewerId: data['reviewerId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      tags: List<String>.from(data['tags'] ?? []),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'propertyId': propertyId,
      'reviewerId': reviewerId,
      'rating': rating,
      'tags': tags,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ReviewModel copyWith({
    double? rating,
    List<String>? tags,
    String? comment,
  }) {
    return ReviewModel(
      id: id,
      propertyId: propertyId,
      reviewerId: reviewerId,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
