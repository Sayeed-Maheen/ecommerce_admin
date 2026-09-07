import 'package:firebase_auth/firebase_auth.dart';

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
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Unable to login');
    }

    return AdminUserModel.fromFirebase(
      id: user.uid,
      email: user.email ?? email,
      name: user.displayName,
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
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
}
