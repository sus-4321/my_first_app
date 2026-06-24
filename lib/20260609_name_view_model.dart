import 'package:flutter/material.dart';
import 'package:my_first_app/20260609_share_preferences_helper_v3.dart';

class NameViewModel extends ChangeNotifier {
  // 引入底層的 Helper
  final SharePreferencesHelperV3 _helper = SharePreferencesHelperV3.instance;

  // 內部狀態
  String _currentName = '';
  bool _isLoading = false;

  // 提供給外部 UI 讀取的公開屬性
  String get currentName => _currentName;
  bool get isLoading => _isLoading; // 新增：讓 UI 可以顯示轉圈圈載入中

  // 商業邏輯：初始化讀取
  Future<void> loadSavedName() async {
    _toggleLoading(true);
    _currentName = await _helper.readName();
    _toggleLoading(false);
  }

  // 商業邏輯：儲存姓名
  Future<void> updateName(String newName) async {
    _toggleLoading(true);
    await _helper.saveName(newName);
    _currentName = newName;
    _toggleLoading(false);
  }

  // 私有工具：切換載入狀態並「主動通知」UI 刷新
  void _toggleLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // 關鍵！只要這行執行，所有綁定的 UI 都會集體刷新
  }
}
