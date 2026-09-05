import '../entities/order_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentOrdersUseCase {
  final DashboardRepository repository;

  GetRecentOrdersUseCase(this.repository);

  Future<List<OrderSummary>> call() async {
    return await repository.getRecentOrders();
  }
}
