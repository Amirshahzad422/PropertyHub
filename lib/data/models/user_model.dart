import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final int role;
  final String? name;
  final String? phone;
  final String? email;
  final String? profilePhotoUrl;
  final Map<String, dynamic>? preferences; 
  final String? agencyInfo;
  final String? licenseNumber;
  final String? about;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.role,
    this.name,
    this.phone,
    this.email,
    this.profilePhotoUrl,
    this.preferences,
    this.agencyInfo,
    this.licenseNumber,
    this.about,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      role: data['role'] ?? 1,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      profilePhotoUrl: data['profilePhotoUrl'],
      preferences: data['preferences'],
      agencyInfo: data['agencyInfo'],
      licenseNumber: data['licenseNumber'],
      about: data['about'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      if (preferences != null && role == 1) 'preferences': preferences,
      if (agencyInfo != null && role == 2) 'agencyInfo': agencyInfo,
      if (licenseNumber != null && role == 2) 'licenseNumber': licenseNumber,
      if (about != null && role == 2) 'about': about,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? profilePhotoUrl,
    Map<String, dynamic>? preferences,
    String? agencyInfo,
    String? licenseNumber,
    String? about,
  }) {
    return UserModel(
      id: id,
      role: role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      preferences: preferences ?? this.preferences,
      agencyInfo: agencyInfo ?? this.agencyInfo,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      about: about ?? this.about,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
