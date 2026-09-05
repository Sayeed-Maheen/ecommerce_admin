import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _preferences;

  PreferencesService(this._preferences);

  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }
}
