import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/datasources/category_remote_data_source.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/create_category_use_case.dart';
import '../../domain/usecases/delete_category_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/update_category_use_case.dart';
import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(FirebaseFirestore.instance),
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<CategoryRemoteDataSource>()),
    );

    Get.lazyPut<GetCategoriesUseCase>(() => GetCategoriesUseCase(Get.find<CategoryRepository>()));

    Get.lazyPut<CreateCategoryUseCase>(() => CreateCategoryUseCase(Get.find<CategoryRepository>()));

    Get.lazyPut<UpdateCategoryUseCase>(() => UpdateCategoryUseCase(Get.find<CategoryRepository>()));

    Get.lazyPut<DeleteCategoryUseCase>(() => DeleteCategoryUseCase(Get.find<CategoryRepository>()));

    Get.lazyPut<CategoryController>(
      () => CategoryController(
        Get.find<GetCategoriesUseCase>(),
        Get.find<CreateCategoryUseCase>(),
        Get.find<UpdateCategoryUseCase>(),
        Get.find<DeleteCategoryUseCase>(),
      ),
    );
  }
}
