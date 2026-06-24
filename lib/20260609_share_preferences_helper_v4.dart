import 'package:shared_preferences/shared_preferences.dart';

/// 【進階安全機制】使用 enum (列舉) 定義全 App 的儲存金鑰 (Key)
/// 這樣做能徹底杜絕工程師因為「手殘打錯字」導致找不到偏好設定的 Bug！
enum StorageKey {
  userName, // 對應原本的姓名字串
  isFirstOpen, // 範例：是否第一次打開 App (布林值)
  themeMode, // 範例：主題風格 (整數或字串)
}

/// 【高級抽象合約】升級為支援「泛型 <T>」的萬用本地儲存合約
abstract class ILocalStorageRepository {
  // 寫入：傳入特定的 StorageKey 與任意型態的數值 T
  Future<bool> write<T>(StorageKey key, T value);

  // 讀取：傳入特定的 StorageKey，並指定想要的型態 T
  Future<T?> read<T>(StorageKey key);

  // 【新增功能】全域刪除：特定某個 Key 的資料
  Future<bool> remove(StorageKey key);

  // 【新增功能】萬能清除：使用者登出時，一鍵清空整台手機的偏好設定
  Future<bool> clearAll();
}

/// 【進階具體實作】完美的通用 SharedPreferences 管理器
class SharePreferencesHelperV4 implements ILocalStorageRepository {
  SharePreferencesHelperV4();

  /// 萬用寫入方法：利用 Dart 的模式匹配 (Pattern Matching) 自動辨別資料型態
  @override
  Future<bool> write<T>(StorageKey key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    // 將 enum 轉為唯一的字串名稱作為 Key (例如: "StorageKey.userName")
    final String keyString = key.toString();

    // 根據傳進來的實體數值型態，呼叫對應的 SharedPreferences 寫入方法
    if (value is String) return await prefs.setString(keyString, value);
    if (value is bool) return await prefs.setBool(keyString, value);
    if (value is int) return await prefs.setInt(keyString, value);
    if (value is double) return await prefs.setDouble(keyString, value);
    if (value is List<String>)
      return await prefs.setStringList(keyString, value);

    // 如果傳入不支援的型態，拋出異常防呆
    throw ArgumentError('SharedPreferences 不支援此型態的儲存：${value.runtimeType}');
  }

  /// 萬用讀取方法：根據外部要求的型態 <T> 自動回傳對應的資料
  @override
  Future<T?> read<T>(StorageKey key) async {
    final prefs = await SharedPreferences.getInstance();
    final String keyString = key.toString();

    // 檢查該 Key 在手機本地端是否存在，若不存在直接回傳 null
    if (!prefs.containsKey(keyString)) return null;

    // 直接將 SharedPreferences 的 get 撈取結果，強制轉型為外部期待的 T 型態
    return prefs.get(keyString) as T?;
  }

  /// 刪除單一 Key
  @override
  Future<bool> remove(StorageKey key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key.toString());
  }

  /// 一鍵清空全域快取 (常用於使用者登出)
  @override
  Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
