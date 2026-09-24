import 'dart:typed_data';

import 'package:ecommerce_admin/features/products/domain/usecases/upload_product_image_use_case.dart';
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
  final UploadProductImageUseCase uploadProductImageUseCase;

  ProductController(
    this.getProductsUseCase,
    this.createProductUseCase,
    this.updateProductUseCase,
    this.deleteProductUseCase,
    this.uploadProductImageUseCase,
  );

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<String?> uploadProductImage({
    required String productId,
    required Uint8List imageBytes,
  }) async {
    try {
      errorMessage.value = '';

      return await uploadProductImageUseCase(productId: productId, imageBytes: imageBytes);
    } on AppException catch (e) {
      errorMessage.value = e.message;
      return null;
    } catch (_) {
      errorMessage.value = 'Unable to upload product image.';
      return null;
    }
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

  Future<bool> createProduct(Product product, {Uint8List? imageBytes}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Create product first to get Firestore document ID.
      var createdProduct = await createProductUseCase(product);

      // 2. Upload image if selected.
      if (imageBytes != null) {
        final imageUrl = await uploadProductImage(
          productId: createdProduct.id,
          imageBytes: imageBytes,
        );

        if (imageUrl == null) {
          await deleteProductUseCase(createdProduct.id);

          if (errorMessage.value.isEmpty) {
            errorMessage.value = 'Unable to upload product image.';
          }

          return false;
        }

        // 3. Update product with image URL.
        createdProduct = await updateProductUseCase(
          Product(
            id: createdProduct.id,
            name: createdProduct.name,
            description: createdProduct.description,
            categoryId: createdProduct.categoryId,
            imageUrl: imageUrl,
            price: createdProduct.price,
            isActive: createdProduct.isActive,
          ),
        );
      }

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

  Future<bool> updateProduct(Product product, {Uint8List? imageBytes}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      var updatedProduct = await updateProductUseCase(product);

      if (imageBytes != null) {
        final imageUrl = await uploadProductImage(
          productId: updatedProduct.id,
          imageBytes: imageBytes,
        );

        if (imageUrl == null) {
          return false;
        }

        updatedProduct = await updateProductUseCase(
          Product(
            id: updatedProduct.id,
            name: updatedProduct.name,
            description: updatedProduct.description,
            categoryId: updatedProduct.categoryId,
            imageUrl: imageUrl,
            price: updatedProduct.price,
            isActive: updatedProduct.isActive,
          ),
        );
      }

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
