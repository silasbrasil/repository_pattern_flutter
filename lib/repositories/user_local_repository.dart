import 'package:shared_preferences/shared_preferences.dart';

class UserLocalRepository {
  final _userPrefsKey = 'userPrefsKey';

  Future<String> get() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.getString(_userPrefsKey);
  }

  Future<bool> save(String user) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.setString(_userPrefsKey, user);
  }

  Future<bool> delete() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.remove(_userPrefsKey);
  }
}