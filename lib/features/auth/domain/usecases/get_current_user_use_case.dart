import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<AdminUser?> call() async {
    return await repository.getCurrentUser();
  }
}
