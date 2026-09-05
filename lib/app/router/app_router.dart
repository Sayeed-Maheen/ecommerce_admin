import 'package:ecommerce_admin/core/bindings/dashboard_binding.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,

    routes: [
      // GoRoute(
      //   path: AppRoutes.dashboard,
      //   name: 'dashboard',
      //   builder: (context, state) {
      //     DashboardBinding().dependencies();
      //     return const DashboardPage();
      //   },
      // ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) {
          DashboardBinding().dependencies();

          return const DashboardPage();
        },
      ),
    ],
  );
}
