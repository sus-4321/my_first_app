import 'package:flutter/material.dart';
import 'package:my_first_app/20260609_share_preferences_helper_v4.dart';

/// 姓名資料的 ViewModel (狀態管理大腦)
class NameViewModelV4 extends ChangeNotifier {
  final ILocalStorageRepository _repository;

  NameViewModelV4(this._repository);

  // --- 內部私有狀態 ---
  String _currentName = '';
  bool _isLoading = false;
  String _errorMessage = '';

  // --- 外部公開唯讀屬性 ---
  String get currentName => _currentName;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// 初始化讀取
  Future<void> loadSavedName() async {
    _setStates(loading: true, error: '');

    try {
      // 【進階調整】呼叫萬用讀取，並明確指定我要讀取出 <String> 型態，且 Key 是 userName
      final savedValue = await _repository.read<String>(StorageKey.userName);
      _currentName = savedValue ?? ''; // 如果是 null 就給予空字串
    } catch (e) {
      _errorMessage = '讀取本地資料失敗：$e';
    } finally {
      _setStates(loading: false);
    }
  }

  /// 儲存姓名
  Future<void> updateName(String newName) async {
    if (newName.trim().isEmpty) {
      _setStates(error: '姓名不能留空喔！');
      return;
    }

    _setStates(loading: true, error: '');

    try {
      // 【進階調整】呼叫萬用寫入，直接傳入安全 Key 值與字串內容
      await _repository.write<String>(StorageKey.userName, newName);
      _currentName = newName;
    } catch (e) {
      _errorMessage = '儲存失敗，請檢查手機空間：$e';
    } finally {
      _setStates(loading: false);
    }
  }

  /// 統一狀態管理工具
  void _setStates({bool? loading, String? error}) {
    if (loading != null) _isLoading = loading;
    if (error != null) _errorMessage = error;
    notifyListeners();
  }
}
