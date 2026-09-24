import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/datasources/cloudinary_product_image_data_source.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_image_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_image_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product_use_case.dart';
import '../../domain/usecases/delete_product_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../../domain/usecases/upload_product_image_use_case.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // -----------------------------
    // Product
    // -----------------------------

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

    // -----------------------------
    // Cloudinary Product Image
    // -----------------------------

    Get.lazyPut<Dio>(() => Dio());

    Get.lazyPut<CloudinaryProductImageDataSource>(
      () => CloudinaryProductImageDataSourceImpl(Get.find<Dio>()),
    );

    Get.lazyPut<ProductImageRepository>(
      () => ProductImageRepositoryImpl(Get.find<CloudinaryProductImageDataSource>()),
    );

    Get.lazyPut<UploadProductImageUseCase>(
      () => UploadProductImageUseCase(Get.find<ProductImageRepository>()),
    );

    // -----------------------------
    // Product Controller
    // -----------------------------

    Get.lazyPut<ProductController>(
      () => ProductController(
        Get.find<GetProductsUseCase>(),
        Get.find<CreateProductUseCase>(),
        Get.find<UpdateProductUseCase>(),
        Get.find<DeleteProductUseCase>(),
        Get.find<UploadProductImageUseCase>(),
      ),
    );
  }
}
