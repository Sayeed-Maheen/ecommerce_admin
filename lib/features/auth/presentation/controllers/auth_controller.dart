import 'package:ecommerce_admin/features/auth/domain/usecases/authorize_admin_use_case.dart';
import 'package:ecommerce_admin/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';

class AuthController extends GetxController {
  final AuthorizeAdminUseCase authorizeAdminUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthController(
    this.authorizeAdminUseCase,
    this.loginUseCase,
    this.logoutUseCase,
    this.getCurrentUserUseCase,
  );

  final Rxn<AdminUser> currentUser = Rxn<AdminUser>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isRestoringSession = true.obs;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await loginUseCase(email: email, password: password);

      try {
        final authorizedUser = await authorizeAdminUseCase(uid: user.id, email: user.email);

        currentUser.value = authorizedUser;

        return true;
      } on AppException catch (e) {
        await logoutUseCase();

        currentUser.value = null;
        errorMessage.value = e.message;

        return false;
      }
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

  Future<void> restoreSession() async {
    try {
      final user = await getCurrentUserUseCase();

      if (user == null) {
        return;
      }

      final authorizedUser = await authorizeAdminUseCase(uid: user.id, email: user.email);

      currentUser.value = authorizedUser;
    } on AppException {
      await logoutUseCase();
      currentUser.value = null;
    } catch (_) {
      await logoutUseCase();
      currentUser.value = null;
    } finally {
      isRestoringSession.value = false;
    }
  }
}
