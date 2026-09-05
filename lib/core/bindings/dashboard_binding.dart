import 'package:ecommerce_admin/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:ecommerce_admin/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:ecommerce_admin/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:ecommerce_admin/features/dashboard/domain/usecases/get_dashboard_stats_use_case.dart';
import 'package:ecommerce_admin/features/dashboard/domain/usecases/get_recent_orders_use_case.dart';
import 'package:ecommerce_admin/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl());

    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find<DashboardRemoteDataSource>()),
    );

    Get.lazyPut<GetDashboardStatsUseCase>(
      () => GetDashboardStatsUseCase(Get.find<DashboardRepository>()),
    );

    Get.lazyPut<GetRecentOrdersUseCase>(
      () => GetRecentOrdersUseCase(Get.find<DashboardRepository>()),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<GetDashboardStatsUseCase>(),
        Get.find<GetRecentOrdersUseCase>(),
      ),
    );
  }
}
