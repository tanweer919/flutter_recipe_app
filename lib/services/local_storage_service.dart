import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);
    return value;
  }

  Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? value = prefs.getStringList(key);
    return value;
  }

  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? value = prefs.getBool(key);
    return value;
  }

  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<Map<String, dynamic>> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final String? refreshToken = prefs.getString('refreshToken');
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  Future<void> setAuthToken({String? accessToken, String? refreshToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await prefs.setString('accessToken', accessToken);
    } else {
      await prefs.remove('accessToken');
    }
    if (refreshToken != null) {
      await prefs.setString('refreshToken', refreshToken);
    } else {
      await prefs.remove('refreshToken');
    }
  }
}
