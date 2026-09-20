import '../entities/admin_user.dart';

abstract class AuthRepository {
  Future<AdminUser> authorizeAdmin({required String uid, required String email});

  Future<AdminUser> login({required String email, required String password});

  Future<void> logout();

  Future<AdminUser?> getCurrentUser();
}
