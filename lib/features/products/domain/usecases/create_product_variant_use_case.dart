import '../entities/product_variant.dart';
import '../repositories/product_variant_repository.dart';

class CreateProductVariantUseCase {
  final ProductVariantRepository repository;

  CreateProductVariantUseCase(this.repository);

  Future<ProductVariant> call(ProductVariant variant) {
    return repository.createVariant(variant);
  }
}
