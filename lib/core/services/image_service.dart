import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickAndCompressImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }

    final bytes = await image.readAsBytes();

    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1200,
      minHeight: 1200,
      quality: 80,
      format: CompressFormat.jpeg,
    );

    return compressedBytes;
  }
}
