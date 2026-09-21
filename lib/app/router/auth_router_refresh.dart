import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';

class AuthRouterRefresh extends ChangeNotifier {
  late final Worker _worker;

  AuthRouterRefresh(AuthController authController) {
    _worker = everAll([
      authController.currentUser,
      authController.isRestoringSession,
    ], (_) => notifyListeners());
  }

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }
}
