import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String id;
  final String propertyId;
  final String buyerId;
  final String ownerId;
  final Map<String, dynamic> personalDetails;
  final Map<String, dynamic> employmentInfo;
  final String references;
  final List<String> documentUrls;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApplicationModel({
    required this.id,
    required this.propertyId,
    required this.buyerId,
    required this.ownerId,
    required this.personalDetails,
    required this.employmentInfo,
    required this.references,
    required this.documentUrls,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ApplicationModel(
      id: doc.id,
      propertyId: data['propertyId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      personalDetails: data['personalDetails'] ?? {},
      employmentInfo: data['employmentInfo'] ?? {},
      references: data['references'] ?? '',
      documentUrls: List<String>.from(data['documentUrls'] ?? []),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'propertyId': propertyId,
      'buyerId': buyerId,
      'ownerId': ownerId,
      'personalDetails': personalDetails,
      'employmentInfo': employmentInfo,
      'references': references,
      'documentUrls': documentUrls,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ApplicationModel copyWith({
    Map<String, dynamic>? personalDetails,
    Map<String, dynamic>? employmentInfo,
    String? references,
    List<String>? documentUrls,
    String? status,
  }) {
    return ApplicationModel(
      id: id,
      propertyId: propertyId,
      buyerId: buyerId,
      ownerId: ownerId,
      personalDetails: personalDetails ?? this.personalDetails,
      employmentInfo: employmentInfo ?? this.employmentInfo,
      references: references ?? this.references,
      documentUrls: documentUrls ?? this.documentUrls,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
