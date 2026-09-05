import 'package:ecommerce_admin/features/dashboard/domain/entities/order_summary.dart';

import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();

  Future<List<OrderSummary>> getRecentOrders();
}
