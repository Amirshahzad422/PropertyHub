import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/data/datasources/firebase_auth_service.dart';
import 'package:propertyhub/data/models/user_model.dart';
import 'package:propertyhub/data/repositories/auth_repository.dart';
import 'package:propertyhub/data/repositories_impl/auth_repository_impl.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'propertyhub');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authService: ref.watch(firebaseAuthServiceProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required int role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithPhone(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      if (e.toString().contains('Google Sign-In aborted') || e.toString().contains('popup_closed_by_user')) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> sendPhoneOTP({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) verificationFailed,
  }) async {
    try {
      await _authRepository.sendPhoneOTP(
        phoneNumber: phoneNumber,
        codeSent: codeSent,
        verificationFailed: verificationFailed,
      );
    } catch (e) {
      verificationFailed(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final updatedUser = await _authRepository.updateUserProfile(user);
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      return await _authRepository.checkEmailExists(email);
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

  Future<void> linkEmailToAccount({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.linkEmailToAccount(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      throw Exception('Failed to link account: $e');
    }
  }
}
