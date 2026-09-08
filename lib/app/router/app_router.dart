import 'package:ecommerce_admin/core/bindings/dashboard_binding.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_binding.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.login,

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          AuthBinding().dependencies();

          return const LoginPage();
        },
      ),

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
