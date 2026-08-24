import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:propertyhub/data/datasources/firebase_auth_service.dart';
import 'package:propertyhub/data/models/user_model.dart';
import 'package:propertyhub/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required FirebaseAuthService authService,
    required FirebaseFirestore firestore,
  })  : _authService = authService,
        _firestore = firestore;

  @override
  Stream<UserModel?> get authStateChanges =>
      _authService.authStateChanges.asyncMap((user) async {
        if (user == null) return null;
        try {
          return await _getUserModelFromFirestore(user.uid);
        } catch (e) {
          await Future.delayed(const Duration(seconds: 2));
          try {
            return await _getUserModelFromFirestore(user.uid);
          } catch (_) {
            return null;
          }
        }
      });

  @override
  UserModel? get currentUser {
    final user = _authService.getCurrentUser();
    if (user == null) return null;
    return null; 
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required int role,
  }) async {
    try {
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      final userModel = _createNewUser(
        user: user,
        role: role,
      );

      await _firestore.collection('users').doc(user.uid).set(
            userModel.toFirestore(),
          );

      return userModel;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      return await _getUserModelFromFirestore(user.uid);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) verificationFailed,
  }) async {
    try {
      await _authService.sendPhoneOTP(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          try {
            await _authService.signInWithPhoneCredential(credential);
          } catch (e) {
            verificationFailed('Auto-verification failed: $e');
          }
        },
        verificationFailed: (error) {
          verificationFailed(error.message ?? 'Verification failed');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  @override
  Future<UserModel> signInWithPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential =
          await _authService.signInWithPhoneCredential(credential);

      final user = userCredential.user!;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        final userModel = _createNewUser(
          user: user,
          role: 1, 
        );

        await _firestore.collection('users').doc(user.uid).set(
              userModel.toFirestore(),
            );

        return userModel;
      }
    } catch (e) {
      throw Exception('Phone sign in failed: $e');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      final user = userCredential.user!;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        final userModel = _createNewUser(
          user: user,
          role: 1,
        );

        await _firestore.collection('users').doc(user.uid).set(
              userModel.toFirestore(),
            );

        return userModel;
      }
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _authService.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(
          user.toFirestore(),
        );
    return user;
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check email existence: $e');
    }
  }

  @override
  Future<UserModel> linkEmailToAccount({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authService.linkEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user!;
      
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return await _getUserModelFromFirestore(user.uid);
    } catch (e) {
      throw Exception('Failed to link email: $e');
    }
  }

  Future<UserModel> _getUserModelFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User document not found');
    }

    return UserModel.fromFirestore(doc);
  }

  UserModel _createNewUser({
    required User user,
    required int role,
  }) {
    return UserModel(
      id: user.uid,
      role: role,
      name: user.displayName ?? '',
      email: user.email,
      phone: user.phoneNumber,
      profilePhotoUrl: user.photoURL,
      preferences: role == 1 ? {} : null,
      agencyInfo: role == 2 ? '' : null,
      licenseNumber: role == 2 ? '' : null,
      about: role == 2 ? '' : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
