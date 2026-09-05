import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../../../app/theme/app_colors.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Column(
      children: [
        _TopBar(),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(controller.errorMessage.value, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.getDashboardStats,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final stats = controller.stats.value;

            if (stats == null) {
              return const Center(child: Text('No dashboard data'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),

                  const SizedBox(height: 8),

                  Text(
                    'Overview of your e-commerce store',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      int columns = 4;

                      if (width < 1100) {
                        columns = 2;
                      }

                      if (width < 600) {
                        columns = 1;
                      }

                      return GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _StatCard(
                            title: 'Products',
                            value: '${stats.totalProducts}',
                            icon: Icons.inventory_2_outlined,
                          ),

                          _StatCard(
                            title: 'Orders',
                            value: '${stats.totalOrders}',
                            icon: Icons.shopping_cart_outlined,
                          ),

                          _StatCard(
                            title: 'Customers',
                            value: '${stats.totalCustomers}',
                            icon: Icons.people_outline,
                          ),

                          _StatCard(
                            title: 'Revenue',
                            value: '\$${stats.totalRevenue.toStringAsFixed(2)}',
                            icon: Icons.attach_money,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  _RecentOrdersCard(),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),

          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined)),

          const SizedBox(width: 8),

          const CircleAvatar(radius: 18, child: Icon(Icons.person_outline, size: 20)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.analytics_outlined, color: AppColors.primary),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Orders', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 20),

            const Divider(),

            Obx(() {
              if (controller.orders.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No recent orders')),
                );
              }

              return Column(
                children: controller.orders
                    .map(
                      (order) => _OrderRow(
                        order: order.orderId,
                        customer: order.customerName,
                        amount: '\$${order.amount.toStringAsFixed(2)}',
                        status: order.status,
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String order;
  final String customer;
  final String amount;
  final String status;

  const _OrderRow({
    required this.order,
    required this.customer,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(order)),
          Expanded(flex: 2, child: Text(customer)),
          Expanded(child: Text(amount)),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: status == 'Completed'
                      ? AppColors.success
                      : status == 'Pending'
                      ? AppColors.warning
                      : AppColors.info,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
