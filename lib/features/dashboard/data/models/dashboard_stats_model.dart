import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalProducts,
    required super.totalOrders,
    required super.totalCustomers,
    required super.totalRevenue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalProducts: json['totalProducts'] as int,
      totalOrders: json['totalOrders'] as int,
      totalCustomers: json['totalCustomers'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'totalCustomers': totalCustomers,
      'totalRevenue': totalRevenue,
    };
  }

  DashboardStats toEntity() {
    return DashboardStats(
      totalProducts: totalProducts,
      totalOrders: totalOrders,
      totalCustomers: totalCustomers,
      totalRevenue: totalRevenue,
    );
  }
}
