import '../repositories/product_storage_repository.dart';

class DeleteProductImageUseCase {
  final ProductStorageRepository repository;

  DeleteProductImageUseCase(this.repository);

  Future<void> call({required String productId}) async {
    await repository.deleteProductImage(productId: productId);
  }
}
