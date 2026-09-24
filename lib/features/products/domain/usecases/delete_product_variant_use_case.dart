import '../repositories/product_variant_repository.dart';

class DeleteProductVariantUseCase {
  final ProductVariantRepository repository;

  DeleteProductVariantUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteVariant(id);
  }
}
