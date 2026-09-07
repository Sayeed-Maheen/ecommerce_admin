import 'package:get/get.dart';

import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthController(this.loginUseCase, this.logoutUseCase);

  final Rxn<AdminUser> currentUser = Rxn<AdminUser>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await loginUseCase(email: email, password: password);

      currentUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await logoutUseCase();

      currentUser.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
