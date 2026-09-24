import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/usecases/create_product_variant_use_case.dart';
import '../../domain/usecases/delete_product_variant_use_case.dart';
import '../../domain/usecases/get_product_variants_use_case.dart';
import '../../domain/usecases/update_product_variant_use_case.dart';

class ProductVariantController extends GetxController {
  final String productId;
  final GetProductVariantsUseCase getProductVariantsUseCase;
  final CreateProductVariantUseCase createProductVariantUseCase;
  final UpdateProductVariantUseCase updateProductVariantUseCase;
  final DeleteProductVariantUseCase deleteProductVariantUseCase;

  ProductVariantController(
    this.productId,
    this.getProductVariantsUseCase,
    this.createProductVariantUseCase,
    this.updateProductVariantUseCase,
    this.deleteProductVariantUseCase,
  );

  final variants = <ProductVariant>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getVariants(productId);
  }

  Future<void> getVariants(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getProductVariantsUseCase(productId);

      variants.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Unable to load product variants.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createVariant(ProductVariant variant) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdVariant = await createProductVariantUseCase(variant);

      variants.add(createdVariant);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to create product variant.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateVariant(ProductVariant variant) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedVariant = await updateProductVariantUseCase(variant);

      final index = variants.indexWhere((item) => item.id == updatedVariant.id);

      if (index != -1) {
        variants[index] = updatedVariant;
      }

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to update product variant.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVariant(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await deleteProductVariantUseCase(id);

      variants.removeWhere((item) => item.id == id);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to delete product variant.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
