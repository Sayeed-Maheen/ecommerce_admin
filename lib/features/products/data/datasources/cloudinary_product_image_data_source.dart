import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/cloudinary_constants.dart';
import '../../../../core/errors/app_exception.dart';

abstract class CloudinaryProductImageDataSource {
  Future<String> uploadProductImage({required String productId, required Uint8List imageBytes});
}

class CloudinaryProductImageDataSourceImpl implements CloudinaryProductImageDataSource {
  final Dio dio;

  CloudinaryProductImageDataSourceImpl(this.dio);

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List imageBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: '$productId.jpg'),
        'upload_preset': CloudinaryConstants.uploadPreset,
      });

      debugPrint('Cloudinary URL: ${CloudinaryConstants.imageUploadUrl}');
      debugPrint('Upload preset: ${CloudinaryConstants.uploadPreset}');

      final response = await dio.post(CloudinaryConstants.imageUploadUrl, data: formData);

      final secureUrl = response.data['secure_url'];

      if (secureUrl == null || secureUrl is! String) {
        throw AppException('Cloudinary did not return an image URL.');
      }

      return secureUrl;
    } on DioException catch (e) {
      throw AppException(
        e.response?.data?['error']?['message']?.toString() ?? 'Unable to upload product image.',
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw AppException('Unable to upload product image.');
    }
  }
}
