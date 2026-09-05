import 'package:ecommerce_admin/features/dashboard/data/models/order_summary_model.dart';

import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<OrderSummaryModel>> getRecentOrders();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = {
      'totalProducts': 120,
      'totalOrders': 48,
      'totalCustomers': 1240,
      'totalRevenue': 12450.0,
    };

    return DashboardStatsModel.fromJson(data);
  }

  @override
  Future<List<OrderSummaryModel>> getRecentOrders() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = [
      {'orderId': '#ORD-1001', 'customerName': 'John Doe', 'amount': 120.00, 'status': 'Completed'},
      {
        'orderId': '#ORD-1002',
        'customerName': 'Sarah Smith',
        'amount': 85.50,
        'status': 'Processing',
      },
      {
        'orderId': '#ORD-1003',
        'customerName': 'Michael Brown',
        'amount': 240.00,
        'status': 'Pending',
      },
      {
        'orderId': '#ORD-1004',
        'customerName': 'Emma Wilson',
        'amount': 65.00,
        'status': 'Completed',
      },
    ];

    return data.map((json) => OrderSummaryModel.fromJson(json)).toList();
  }
}
