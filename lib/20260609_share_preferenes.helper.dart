import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesHelper {
  // 【優化】移除原本的 SharePreferencesHelper();
  // 只留下私有建構子，嚴格限制外部只能透過 .instance 取得物件
  SharePreferencesHelper._();

  // 建立全域唯一的靜態常數實例
  static final SharePreferencesHelper instance = SharePreferencesHelper._();

  // 設定本地儲存的 Key 值
  static const String _keyName = 'name';

  // 儲存姓名的異步方法
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // 讀取姓名的異步方法
  Future<String> readName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? '';
  }
}
