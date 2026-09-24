import 'dart:typed_data';

abstract class ProductImageRepository {
  Future<String> uploadProductImage({required String productId, required Uint8List imageBytes});
}
