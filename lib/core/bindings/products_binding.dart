import 'package:ecommerce_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_admin/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_admin/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_admin/features/products/domain/usecases/get_products_use_case.dart';
import 'package:ecommerce_admin/features/products/presentation/controllers/product_controller.dart';
import 'package:get/get.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl());

    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
    );

    Get.lazyPut<GetProductsUseCase>(() => GetProductsUseCase(Get.find<ProductRepository>()));

    Get.lazyPut<ProductController>(() => ProductController(Get.find<GetProductsUseCase>()));
  }
}
