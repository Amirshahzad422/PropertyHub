import 'package:cloud_firestore/cloud_firestore.dart';

class SavedSearchModel {
  final String id;
  final String userId;
  final Map<String, dynamic> filters;
  final bool alertsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedSearchModel({
    required this.id,
    required this.userId,
    required this.filters,
    required this.alertsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedSearchModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SavedSearchModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      filters: data['filters'] ?? {},
      alertsEnabled: data['alertsEnabled'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'filters': filters,
      'alertsEnabled': alertsEnabled,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SavedSearchModel copyWith({
    Map<String, dynamic>? filters,
    bool? alertsEnabled,
  }) {
    return SavedSearchModel(
      id: id,
      userId: userId,
      filters: filters ?? this.filters,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
