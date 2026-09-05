import 'package:ecommerce_admin/features/dashboard/domain/entities/order_summary.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource dataSource;

  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<DashboardStats> getDashboardStats() async {
    final model = await dataSource.getDashboardStats();

    return model.toEntity();
  }

  @override
  Future<List<OrderSummary>> getRecentOrders() async {
    final models = await dataSource.getRecentOrders();

    return models.map((model) => model.toEntity()).toList();
  }
}
