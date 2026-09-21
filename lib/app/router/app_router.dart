import 'package:ecommerce_admin/app/router/auth_router_refresh.dart';
import 'package:ecommerce_admin/core/bindings/dashboard_binding.dart';
import 'package:ecommerce_admin/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final authController = Get.find<AuthController>();

  static final authRouterRefresh = AuthRouterRefresh(authController);

  static final router = GoRouter(
    initialLocation: AppRoutes.login,

    refreshListenable: authRouterRefresh,

    redirect: (context, state) {
      if (authController.isRestoringSession.value) {
        return null;
      }

      final isLoggedIn = authController.currentUser.value != null;
      final isLoginPage = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoginPage) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoginPage) {
        return AppRoutes.dashboard;
      }

      return null;
    },

    routes: [
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginPage()),

      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) {
          DashboardBinding().dependencies();
          return const DashboardPage();
        },
      ),
    ],
  );
}
