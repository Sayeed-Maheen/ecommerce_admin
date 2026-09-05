import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/bindings/initial_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  Get.put<SharedPreferences>(preferences, permanent: true);

  InitialBindings().dependencies();

  runApp(const EcommerceAdminApp());
}

class EcommerceAdminApp extends StatelessWidget {
  const EcommerceAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Commerce Admin',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      themeMode: ThemeMode.system,

      routerConfig: AppRouter.router,
    );
  }
}
