import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category_use_case.dart';
import '../../domain/usecases/delete_category_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/update_category_use_case.dart';

class CategoryController extends GetxController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryController(
    this.getCategoriesUseCase,
    this.createCategoryUseCase,
    this.updateCategoryUseCase,
    this.deleteCategoryUseCase,
  );

  final categories = <Category>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getCategoriesUseCase();

      categories.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Unable to load categories.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCategory(Category category) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdCategory = await createCategoryUseCase(category);

      categories.add(createdCategory);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to create category.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedCategory = await updateCategoryUseCase(category);

      final index = categories.indexWhere((item) => item.id == updatedCategory.id);

      if (index != -1) {
        categories[index] = updatedCategory;
      }

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to update category.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await deleteCategoryUseCase(id);

      categories.removeWhere((item) => item.id == id);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (e) {
      debugPrint('CREATE CATEGORY ERROR: $e');
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
