import 'package:propertyhub/data/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;

  UserModel? get currentUser;

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required int role,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) verificationFailed,
  });

  Future<UserModel> signInWithPhone({
    required String verificationId,
    required String smsCode,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  Future<UserModel> updateUserProfile(UserModel user);

  Future<bool> checkEmailExists(String email);
  
  Future<UserModel> linkEmailToAccount({
    required String email,
    required String password,
  });
}
