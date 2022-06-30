import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/services/storage_keys.dart';

class Storage {
  final SharedPreferences _storage;

  Storage(this._storage);

  Future<void> setData(String email, String password) async {
    await _storage.setString(StorageKeys.email, email);
    await _storage.setString(StorageKeys.password, password);
  }

  String? getEmail() {
    return _storage.getString(StorageKeys.email);
  }

  String? getPassword() {
    return _storage.getString(StorageKeys.password);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
