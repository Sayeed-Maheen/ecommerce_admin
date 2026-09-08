import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
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

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await loginUseCase(email: email, password: password);

      currentUser.value = user;

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await logoutUseCase();

      currentUser.value = null;

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to logout. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
