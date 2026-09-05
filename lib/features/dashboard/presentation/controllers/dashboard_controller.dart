import 'package:ecommerce_admin/features/dashboard/domain/entities/order_summary.dart';
import 'package:ecommerce_admin/features/dashboard/domain/usecases/get_recent_orders_use_case.dart';
import 'package:get/get.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/usecases/get_dashboard_stats_use_case.dart';

class DashboardController extends GetxController {
  // ==============================
  // Dependencies
  // ==============================

  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetRecentOrdersUseCase getRecentOrdersUseCase;

  DashboardController(this.getDashboardStatsUseCase, this.getRecentOrdersUseCase);

  // ==============================
  // Dashboard State
  // ==============================

  final Rxn<DashboardStats> stats = Rxn<DashboardStats>();
  final orders = <OrderSummary>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  // ==============================
  // Sidebar State
  // ==============================

  final selectedMenuIndex = 0.obs;

  void selectMenu(int index) {
    selectedMenuIndex.value = index;
  }

  // ==============================
  // Lifecycle
  // ==============================

  @override
  void onInit() {
    super.onInit();

    getDashboardStats();
    getRecentOrders();
  }

  // ==============================
  // Dashboard Actions
  // ==============================

  Future<void> getDashboardStats() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getDashboardStatsUseCase();

      stats.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecentOrders() async {
    try {
      final result = await getRecentOrdersUseCase();

      orders.assignAll(result);
    } catch (e) {
      // We can introduce separate error handling later.
    }
  }
}
