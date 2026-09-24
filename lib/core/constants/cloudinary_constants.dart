abstract final class CloudinaryConstants {
  static const cloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');

  static const uploadPreset = String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET');

  static String get imageUploadUrl => 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
