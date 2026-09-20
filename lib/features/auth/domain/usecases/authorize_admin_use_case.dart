import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class AuthorizeAdminUseCase {
  final AuthRepository repository;

  AuthorizeAdminUseCase(this.repository);

  Future<AdminUser> call({required String uid, required String email}) async {
    return await repository.authorizeAdmin(uid: uid, email: email);
  }
}
