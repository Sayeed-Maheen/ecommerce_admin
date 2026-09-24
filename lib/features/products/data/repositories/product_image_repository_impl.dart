import 'dart:typed_data';

import '../../domain/repositories/product_image_repository.dart';
import '../datasources/cloudinary_product_image_data_source.dart';

class ProductImageRepositoryImpl implements ProductImageRepository {
  final CloudinaryProductImageDataSource dataSource;

  ProductImageRepositoryImpl(this.dataSource);

  @override
  Future<String> uploadProductImage({required String productId, required Uint8List imageBytes}) {
    return dataSource.uploadProductImage(productId: productId, imageBytes: imageBytes);
  }
}
