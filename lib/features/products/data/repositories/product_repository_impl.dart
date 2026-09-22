import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await dataSource.getProducts();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final model = ProductModel.fromEntity(product);

    final createdModel = await dataSource.createProduct(model);

    return createdModel.toEntity();
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);

    final updatedModel = await dataSource.updateProduct(model);

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteProduct(String id) async {
    await dataSource.deleteProduct(id);
  }
}
