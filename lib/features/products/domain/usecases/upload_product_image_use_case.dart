import 'dart:typed_data';

import '../repositories/product_storage_repository.dart';

class UploadProductImageUseCase {
  final ProductStorageRepository repository;

  UploadProductImageUseCase(this.repository);

  Future<String> call({required String productId, required Uint8List imageBytes}) async {
    return await repository.uploadProductImage(productId: productId, imageBytes: imageBytes);
  }
}
