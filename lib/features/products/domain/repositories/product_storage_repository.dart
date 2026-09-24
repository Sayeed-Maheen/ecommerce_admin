import 'dart:typed_data';

abstract class ProductStorageRepository {
  Future<String> uploadProductImage({required String productId, required Uint8List imageBytes});

  Future<void> deleteProductImage({required String productId});
}
