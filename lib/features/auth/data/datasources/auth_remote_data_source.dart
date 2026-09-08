import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/admin_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AdminUserModel> login({required String email, required String password});

  Future<void> logout();

  Future<AdminUserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<AdminUserModel> login({required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AppException('Unable to login.');
      }

      return AdminUserModel.fromFirebase(
        id: user.uid,
        email: user.email ?? email,
        name: user.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AppException(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<AdminUserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return AdminUserModel.fromFirebase(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      default:
        return 'Unable to login. Please try again.';
    }
  }
}
