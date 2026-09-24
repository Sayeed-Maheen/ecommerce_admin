import '../../domain/entities/product_variant.dart';
import '../../domain/repositories/product_variant_repository.dart';
import '../datasources/product_variant_remote_data_source.dart';
import '../models/product_variant_model.dart';

class ProductVariantRepositoryImpl implements ProductVariantRepository {
  final ProductVariantRemoteDataSource dataSource;

  ProductVariantRepositoryImpl(this.dataSource);

  @override
  Future<List<ProductVariant>> getVariants(String productId) async {
    final models = await dataSource.getVariants(productId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ProductVariant> createVariant(ProductVariant variant) async {
    final model = ProductVariantModel.fromEntity(variant);

    final createdModel = await dataSource.createVariant(model);

    return createdModel.toEntity();
  }

  @override
  Future<ProductVariant> updateVariant(ProductVariant variant) async {
    final model = ProductVariantModel.fromEntity(variant);

    final updatedModel = await dataSource.updateVariant(model);

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteVariant(String id) {
    return dataSource.deleteVariant(id);
  }
}
