import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call() async {
    final products = await repository.getProducts();

    return products.where((product) => product.isActive).toList();
  }
}
