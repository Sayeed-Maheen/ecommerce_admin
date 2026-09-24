import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/features/products/data/datasources/product_storage_data_source.dart';
import 'package:ecommerce_admin/features/products/data/repositories/product_storage_repository_impl.dart';
import 'package:ecommerce_admin/features/products/domain/repositories/product_storage_repository.dart';
import 'package:ecommerce_admin/features/products/domain/usecases/delete_product_image_use_case.dart';
import 'package:ecommerce_admin/features/products/domain/usecases/upload_product_image_use_case.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product_use_case.dart';
import '../../domain/usecases/delete_product_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(FirebaseFirestore.instance),
    );

    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
    );

    Get.lazyPut<GetProductsUseCase>(() => GetProductsUseCase(Get.find<ProductRepository>()));

    Get.lazyPut<CreateProductUseCase>(() => CreateProductUseCase(Get.find<ProductRepository>()));

    Get.lazyPut<UpdateProductUseCase>(() => UpdateProductUseCase(Get.find<ProductRepository>()));

    Get.lazyPut<DeleteProductUseCase>(() => DeleteProductUseCase(Get.find<ProductRepository>()));

    Get.lazyPut<ProductController>(
      () => ProductController(
        Get.find<GetProductsUseCase>(),
        Get.find<CreateProductUseCase>(),
        Get.find<UpdateProductUseCase>(),
        Get.find<DeleteProductUseCase>(),
        Get.find<UploadProductImageUseCase>(),
      ),
    );

    Get.lazyPut<ProductStorageDataSource>(
      () => ProductStorageDataSourceImpl(FirebaseStorage.instance),
    );

    Get.lazyPut<ProductStorageRepository>(
      () => ProductStorageRepositoryImpl(Get.find<ProductStorageDataSource>()),
    );

    Get.lazyPut<UploadProductImageUseCase>(
      () => UploadProductImageUseCase(Get.find<ProductStorageRepository>()),
    );

    Get.lazyPut<DeleteProductImageUseCase>(
      () => DeleteProductImageUseCase(Get.find<ProductStorageRepository>()),
    );
  }
}
