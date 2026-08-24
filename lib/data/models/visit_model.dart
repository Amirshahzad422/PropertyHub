import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final String id;
  final String propertyId;
  final String buyerId;
  final String ownerId;
  final DateTime scheduledDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitModel({
    required this.id,
    required this.propertyId,
    required this.buyerId,
    required this.ownerId,
    required this.scheduledDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return VisitModel(
      id: doc.id,
      propertyId: data['propertyId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
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
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  VisitModel copyWith({
    DateTime? scheduledDate,
    String? status,
  }) {
    return VisitModel(
      id: id,
      propertyId: propertyId,
      buyerId: buyerId,
      ownerId: ownerId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
