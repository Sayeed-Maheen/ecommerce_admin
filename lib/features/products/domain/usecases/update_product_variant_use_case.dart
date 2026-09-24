import '../entities/product_variant.dart';
import '../repositories/product_variant_repository.dart';

class UpdateProductVariantUseCase {
  final ProductVariantRepository repository;

  UpdateProductVariantUseCase(this.repository);

  Future<ProductVariant> call(ProductVariant variant) {
    return repository.updateVariant(variant);
  }
}
