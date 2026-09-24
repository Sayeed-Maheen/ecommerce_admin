import 'dart:typed_data';

import '../../domain/repositories/product_storage_repository.dart';
import '../datasources/product_storage_data_source.dart';

class ProductStorageRepositoryImpl implements ProductStorageRepository {
  final ProductStorageDataSource dataSource;

  ProductStorageRepositoryImpl(this.dataSource);

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List imageBytes,
  }) async {
    return await dataSource.uploadProductImage(productId: productId, imageBytes: imageBytes);
  }

  @override
  Future<void> deleteProductImage({required String productId}) async {
    await dataSource.deleteProductImage(productId: productId);
  }
}
