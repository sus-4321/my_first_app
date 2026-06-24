// 引入官方本地儲存套件
import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesHelperV2 {
  // 1. 私有建構子（帶有底線），嚴格限制外部無法透過普通的 () 建立新物件
  SharePreferencesHelperV2._();

  // 2. 建立全域唯一的靜態常數實例，確保全 App 數據同步
  static final SharePreferencesHelperV2 instance = SharePreferencesHelperV2._();

  // 本地儲存的 Key 值常數
  static const String _keyName = 'name';

  // 3. 儲存姓名的異步方法
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // 4. 讀取姓名的異步方法
  Future<String> readName() async {
    final prefs = await SharedPreferences.getInstance();
    // 如果讀出來是 null（代表沒存過），就回傳空字串 ''
    return prefs.getString(_keyName) ?? '';
  }
}
