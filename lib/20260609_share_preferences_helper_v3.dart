import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesHelperV3 {
  SharePreferencesHelperV3._();
  static final SharePreferencesHelperV3 instance = SharePreferencesHelperV3._();

  static const String _keyName = 'name';

  // 純粹的底層寫入
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // 純粹的底層讀取
  Future<String> readName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? '';
  }
}
