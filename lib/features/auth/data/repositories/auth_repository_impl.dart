import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<AdminUser> login({required String email, required String password}) async {
    final model = await dataSource.login(email: email, password: password);

    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<AdminUser?> getCurrentUser() async {
    final model = await dataSource.getCurrentUser();

    return model?.toEntity();
  }
}
