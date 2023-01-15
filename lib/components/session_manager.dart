import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  late final SharedPreferences prefs;

  Future<void> setAuthToken(
      String userId, String username, String password) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  Future<String?> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userId');
  }

  Future<String?> getUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('username');
  }

  Future<String?> getPassword() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('password');
  }

  clearAll() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
