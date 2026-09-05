import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<PreferencesService>(
      PreferencesService(Get.find<SharedPreferences>()),
      permanent: true,
    );

    Get.put<SecureStorageService>(
      SecureStorageService(const FlutterSecureStorage()),
      permanent: true,
    );
  }
}
