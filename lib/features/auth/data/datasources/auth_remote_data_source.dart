import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/admin_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AdminUserModel> authorizeAdmin({required String uid, required String email});

  Future<AdminUserModel> login({required String email, required String password});

  Future<void> logout();

  Future<AdminUserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Future<AdminUserModel> authorizeAdmin({required String uid, required String email}) async {
    final doc = await firestore.collection('admins').doc(uid).get();

    if (!doc.exists) {
      throw const AppException('User is not authorized as an admin.');
    }

    final data = doc.data();

    if (data == null) {
      throw const AppException('User is not authorized as an admin.');
    }

    final role = data['role'];
    final isActive = data['isActive'];

    if (role != 'admin') {
      throw const AppException('User is not authorized as an admin.');
    }

    if (isActive != true) {
      throw const AppException('Admin account is inactive.');
    }

    return AdminUserModel.fromFirebase(id: uid, email: email, name: data['name'] as String?);
  }

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
