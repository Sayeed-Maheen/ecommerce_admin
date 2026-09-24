import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/app_exception.dart';

abstract class ProductStorageDataSource {
  Future<String> uploadProductImage({required String productId, required Uint8List imageBytes});

  Future<void> deleteProductImage({required String productId});
}

class ProductStorageDataSourceImpl implements ProductStorageDataSource {
  final FirebaseStorage storage;

  ProductStorageDataSourceImpl(this.storage);

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List imageBytes,
  }) async {
    try {
      final ref = storage.ref().child('products').child('$productId.jpg');

      await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to upload product image.');
    }
  }

  @override
  Future<void> deleteProductImage({required String productId}) async {
    try {
      final ref = storage.ref().child('products').child('$productId.jpg');

      await ref.delete();
    } on FirebaseException catch (e) {
      // Ignore if the image doesn't exist.
      if (e.code != 'object-not-found') {
        throw AppException(e.message ?? 'Unable to delete product image.');
      }
    }
  }
}
