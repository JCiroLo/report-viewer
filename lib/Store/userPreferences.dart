import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set username(String value) {
    _prefs.setString('username', value);
  }

  String get username {
    return _prefs.getString('username') ?? '';
  }

  set userToken(String value) {
    _prefs.setString('userToken', value);
  }

  String get userToken {
    return _prefs.getString('userToken') ?? '';
  }

  set userTokenExpiration(int value) {
    _prefs.setInt('userTokenExpiration', value);
  }

  int get userTokenExpiration {
    return _prefs.getInt('userTokenExpiration') ?? 0;
  }
}
