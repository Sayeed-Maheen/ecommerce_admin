import '../entities/product_variant.dart';

abstract class ProductVariantRepository {
  Future<List<ProductVariant>> getVariants(String productId);

  Future<ProductVariant> createVariant(ProductVariant variant);

  Future<ProductVariant> updateVariant(ProductVariant variant);

  Future<void> deleteVariant(String id);
}
