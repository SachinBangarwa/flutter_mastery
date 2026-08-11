import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _keyLoggedIn = 'is_logged_in';

  static bool getLoggedIn() {
    try {
      return _prefs.getBool(_keyLoggedIn) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyLoggedIn, value);
  }
}
