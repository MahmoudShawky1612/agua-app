import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<void> saveUser(String username, int userId, String gender) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('username', username);
    await sharedPref.setInt('userId', userId);
    await sharedPref.setString('gender', gender);
  }
}