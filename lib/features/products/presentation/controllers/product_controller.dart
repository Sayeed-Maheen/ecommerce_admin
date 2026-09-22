import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_use_case.dart';
import '../../domain/usecases/delete_product_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';

class ProductController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductController(
    this.getProductsUseCase,
    this.createProductUseCase,
    this.updateProductUseCase,
    this.deleteProductUseCase,
  );

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getProductsUseCase();

      products.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Unable to load products.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdProduct = await createProductUseCase(product);

      products.add(createdProduct);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to create product.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedProduct = await updateProductUseCase(product);

      final index = products.indexWhere((item) => item.id == updatedProduct.id);

      if (index != -1) {
        products[index] = updatedProduct;
      }

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to update product.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await deleteProductUseCase(id);

      products.removeWhere((item) => item.id == id);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to delete product.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
