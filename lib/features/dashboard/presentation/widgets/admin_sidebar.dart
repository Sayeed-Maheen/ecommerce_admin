import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

class AdminSidebarLayout extends StatelessWidget {
  final Widget child;

  const AdminSidebarLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(title: const Text('E-Commerce Admin')),
            drawer: Drawer(
              child: SafeArea(child: _Sidebar(controller: controller)),
            ),
            body: child,
          );
        }

        return Row(
          children: [
            SizedBox(width: 250, child: _Sidebar(controller: controller)),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  final DashboardController controller;

  const _Sidebar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'E-Commerce',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _MenuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    selected: controller.selectedMenuIndex.value == 0,
                    onTap: () => controller.selectMenu(0),
                  ),

                  _MenuItem(
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    selected: controller.selectedMenuIndex.value == 1,
                    onTap: () => controller.selectMenu(1),
                  ),

                  _MenuItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                    selected: controller.selectedMenuIndex.value == 2,
                    onTap: () => controller.selectMenu(2),
                  ),

                  _MenuItem(
                    icon: Icons.warehouse_outlined,
                    title: 'Inventory',
                    selected: controller.selectedMenuIndex.value == 3,
                    onTap: () => controller.selectMenu(3),
                  ),

                  _MenuItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Offers',
                    selected: controller.selectedMenuIndex.value == 4,
                    onTap: () => controller.selectMenu(4),
                  ),

                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'SALES',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                  ),

                  _MenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Orders',
                    selected: controller.selectedMenuIndex.value == 5,
                    onTap: () => controller.selectMenu(5),
                  ),

                  _MenuItem(
                    icon: Icons.people_outline,
                    title: 'Customers',
                    selected: controller.selectedMenuIndex.value == 6,
                    onTap: () => controller.selectMenu(6),
                  ),

                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'SYSTEM',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                  ),

                  _MenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    selected: controller.selectedMenuIndex.value == 7,
                    onTap: () => controller.selectMenu(7),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(Icons.person_outline, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Administrator', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: selected ? AppColors.primary : null),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.primary : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
