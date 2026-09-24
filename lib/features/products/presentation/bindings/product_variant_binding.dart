import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/datasources/product_variant_remote_data_source.dart';
import '../../data/repositories/product_variant_repository_impl.dart';
import '../../domain/repositories/product_variant_repository.dart';
import '../../domain/usecases/create_product_variant_use_case.dart';
import '../../domain/usecases/delete_product_variant_use_case.dart';
import '../../domain/usecases/get_product_variants_use_case.dart';
import '../../domain/usecases/update_product_variant_use_case.dart';
import '../controllers/product_variant_controller.dart';

class ProductVariantBinding extends Bindings {
  ProductVariantBinding({required this.productId});

  final String productId;

  @override
  void dependencies() {
    Get.lazyPut<ProductVariantRemoteDataSource>(
      () => ProductVariantRemoteDataSourceImpl(FirebaseFirestore.instance),
    );

    Get.lazyPut<ProductVariantRepository>(
      () => ProductVariantRepositoryImpl(Get.find<ProductVariantRemoteDataSource>()),
    );

    Get.lazyPut<GetProductVariantsUseCase>(
      () => GetProductVariantsUseCase(Get.find<ProductVariantRepository>()),
    );

    Get.lazyPut<CreateProductVariantUseCase>(
      () => CreateProductVariantUseCase(Get.find<ProductVariantRepository>()),
    );

    Get.lazyPut<UpdateProductVariantUseCase>(
      () => UpdateProductVariantUseCase(Get.find<ProductVariantRepository>()),
    );

    Get.lazyPut<DeleteProductVariantUseCase>(
      () => DeleteProductVariantUseCase(Get.find<ProductVariantRepository>()),
    );

    Get.lazyPut<ProductVariantController>(
      () => ProductVariantController(
        productId,
        Get.find<GetProductVariantsUseCase>(),
        Get.find<CreateProductVariantUseCase>(),
        Get.find<UpdateProductVariantUseCase>(),
        Get.find<DeleteProductVariantUseCase>(),
      ),
    );
  }
}
