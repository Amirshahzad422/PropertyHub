import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String buyerId;
  final String ownerId;
  final String propertyId;
  final Map<String, int> unreadCounts;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.buyerId,
    required this.ownerId,
    required this.propertyId,
    required this.unreadCounts,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      propertyId: data['propertyId'] ?? '',
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'buyerId': buyerId,
      'ownerId': ownerId,
      'propertyId': propertyId,
      'unreadCounts': unreadCounts,
      'lastUpdated': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  int getUnreadForUser(String userId) {
    return unreadCounts[userId] ?? 0;
  }

  ChatModel copyWith({
    Map<String, int>? unreadCounts,
    DateTime? lastUpdated,
  }) {
    return ChatModel(
      id: id,
      buyerId: buyerId,
      ownerId: ownerId,
      propertyId: propertyId,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
