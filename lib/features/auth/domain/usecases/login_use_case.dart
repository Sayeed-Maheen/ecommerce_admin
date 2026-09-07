import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AdminUser> call({required String email, required String password}) async {
    if (email.trim().isEmpty) {
      throw Exception('Email is required');
    }

    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    return await repository.login(email: email.trim(), password: password);
  }
}
