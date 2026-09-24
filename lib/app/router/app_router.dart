import 'package:ecommerce_admin/app/router/auth_router_refresh.dart';
import 'package:ecommerce_admin/core/bindings/dashboard_binding.dart';
import 'package:ecommerce_admin/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ecommerce_admin/features/categories/domain/entities/category.dart';
import 'package:ecommerce_admin/features/categories/presentation/bindings/category_binding.dart';
import 'package:ecommerce_admin/features/categories/presentation/pages/categories_page.dart';
import 'package:ecommerce_admin/features/categories/presentation/pages/category_form_page.dart';
import 'package:ecommerce_admin/features/products/domain/entities/product.dart';
import 'package:ecommerce_admin/features/products/presentation/bindings/product_binding.dart';
import 'package:ecommerce_admin/features/products/presentation/bindings/product_variant_binding.dart';
import 'package:ecommerce_admin/features/products/presentation/pages/product_form_page.dart';
import 'package:ecommerce_admin/features/products/presentation/pages/product_variant_form_page.dart';
import 'package:ecommerce_admin/features/products/presentation/pages/product_variant_route_args.dart';
import 'package:ecommerce_admin/features/products/presentation/pages/product_variants_page.dart';
import 'package:ecommerce_admin/features/products/presentation/pages/products_page.dart';
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

      GoRoute(
        path: AppRoutes.categories,
        builder: (context, state) {
          CategoryBinding().dependencies();
          return const CategoriesPage();
        },
      ),

      GoRoute(
        path: '/categories/add',
        builder: (context, state) {
          return const CategoryFormPage();
        },
      ),

      GoRoute(
        path: '/categories/edit/:id',
        builder: (context, state) {
          final category = state.extra as Category;
          return CategoryFormPage(category: category);
        },
      ),

      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) {
          ProductBinding().dependencies();
          CategoryBinding().dependencies();

          return const ProductsPage();
        },
      ),

      GoRoute(
        path: '/products/add',
        builder: (context, state) {
          ProductBinding().dependencies();
          CategoryBinding().dependencies();

          return const ProductFormPage();
        },
      ),

      GoRoute(
        path: '/products/edit/:id',
        builder: (context, state) {
          final product = state.extra as Product;

          ProductBinding().dependencies();
          CategoryBinding().dependencies();

          return ProductFormPage(product: product);
        },
      ),

      GoRoute(
        path: '/products/:id/variants',
        builder: (context, state) {
          final product = state.extra as Product;

          ProductVariantBinding(productId: product.id).dependencies();

          return ProductVariantsPage(product: product);
        },
      ),

      GoRoute(
        path: '/products/:id/variants/add',
        builder: (context, state) {
          final product = state.extra as Product;

          ProductVariantBinding(productId: product.id).dependencies();

          return ProductVariantFormPage(args: ProductVariantRouteArgs(product: product));
        },
      ),

      GoRoute(
        path: '/products/:productId/variants/edit/:variantId',
        builder: (context, state) {
          final args = state.extra as ProductVariantRouteArgs;

          ProductVariantBinding(productId: args.product.id).dependencies();

          return ProductVariantFormPage(args: args);
        },
      ),
    ],
  );
}
