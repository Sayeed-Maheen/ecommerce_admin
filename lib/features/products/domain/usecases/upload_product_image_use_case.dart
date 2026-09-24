import 'dart:typed_data';

import '../repositories/product_image_repository.dart';

class UploadProductImageUseCase {
  final ProductImageRepository repository;

  UploadProductImageUseCase(this.repository);

  Future<String> call({required String productId, required Uint8List imageBytes}) {
    return repository.uploadProductImage(productId: productId, imageBytes: imageBytes);
  }
}
