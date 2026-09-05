import 'package:flutter/material.dart';

import '../widgets/admin_sidebar.dart';
import '../widgets/dashboard_content.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AdminSidebarLayout(child: DashboardContent()));
  }
}
