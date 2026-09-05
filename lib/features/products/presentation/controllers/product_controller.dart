import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_use_case.dart';

class ProductController extends GetxController {
  final GetProductsUseCase getProductsUseCase;

  ProductController(this.getProductsUseCase);

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
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
