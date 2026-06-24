import 'package:get_it/get_it.dart';
import 'package:my_first_app/20260609_share_preferences_helper_v4.dart';
import 'package:my_first_app/20260609_name_view_model_v4.dart';

// 建立全域依賴注入定位器
final GetIt locator = GetIt.instance;

void setupLocator() {
  // 註冊萬用型儲存服務
  locator.registerLazySingleton<ILocalStorageRepository>(
    () => SharePreferencesHelperV4(),
  );

  // 註冊大腦 ViewModel
  locator.registerLazySingleton<NameViewModelV4>(
    () => NameViewModelV4(locator<ILocalStorageRepository>()),
  );
}
