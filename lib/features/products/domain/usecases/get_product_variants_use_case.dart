import '../entities/product_variant.dart';
import '../repositories/product_variant_repository.dart';

class GetProductVariantsUseCase {
  final ProductVariantRepository repository;

  GetProductVariantsUseCase(this.repository);

  Future<List<ProductVariant>> call(String productId) {
    return repository.getVariants(productId);
  }
}
