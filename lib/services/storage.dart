import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/services/storage_keys.dart';

class Storage {
  static late final SharedPreferences _storage;

  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static Future<void> setData(String email, String password) async {
    await _storage.setString(StorageKeys.email, email);
    await _storage.setString(StorageKeys.password, password);
  }

  static String? getEmail() {
    return _storage.getString(StorageKeys.email);
  }

  static String? getPassword() {
    return _storage.getString(StorageKeys.password);
  }

  static Future<void> clear() async {
    await _storage.clear();
  }
}
