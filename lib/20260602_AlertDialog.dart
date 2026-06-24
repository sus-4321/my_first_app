import 'package:flutter/material.dart';

// 程式進入點
void main() {
  runApp(const MyApp());
}

// 主程式
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '對話盒範例', // APP名稱
      // 主題設定
      theme: ThemeData(primarySwatch: Colors.blue),

      // 首頁
      home: const MyHomePage(),
    );
  }
}

// 首頁 StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // 城市資料
  static const List<String> cities = ['倫敦', '東京', '舊金山'];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 首頁狀態類別
class _MyHomePageState extends State<MyHomePage> {
  // 儲存對話盒回傳結果
  final ValueNotifier<String> _dialogResult = ValueNotifier('');

  // 儲存選擇的城市索引
  final ValueNotifier<int?> _selectedCity = ValueNotifier(null);

  @override
  void dispose() {
    // 釋放記憶體
    _dialogResult.dispose();
    _selectedCity.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 上方標題列
      appBar: AppBar(title: const Text('對話盒範例')),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // 顯示對話盒按鈕
            ElevatedButton(
              onPressed: () async {
                // 等待對話盒回傳結果
                final result = await _showCityDialog(context);

                // 更新結果文字
                _dialogResult.value = result ?? '';
              },

              child: const Text('顯示對話盒', style: TextStyle(fontSize: 20)),
            ),

            // 間距
            const SizedBox(height: 20),

            // 顯示回傳結果
            ValueListenableBuilder<String>(
              valueListenable: _dialogResult,
              builder: _buildDialogResult,
            ),
          ],
        ),
      ),
    );
  }

  // 顯示城市選擇對話盒
  Future<String?> _showCityDialog(BuildContext context) {
    return showDialog<String>(
      context: context,

      builder: (context) {
        return AlertDialog(
          // 圓角設定
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // 內容邊距
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

          // 城市選項
          content: ValueListenableBuilder<int?>(
            valueListenable: _selectedCity,
            builder: _buildCityOptions,
          ),

          actions: [
            // 取消按鈕
            TextButton(
              onPressed: () {
                // 關閉對話盒並回傳空字串
                Navigator.pop(context, '');
              },

              child: const Text(
                '取消',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),

            // 確定按鈕
            TextButton(
              onPressed: () {
                // 關閉對話盒並回傳選擇城市
                Navigator.pop(
                  context,

                  _selectedCity.value == null
                      ? ''
                      : MyHomePage.cities[_selectedCity.value!],
                );
              },

              child: const Text(
                '確定',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  // 顯示對話盒回傳結果
  Widget _buildDialogResult(
    BuildContext context,
    String result,
    Widget? child,
  ) {
    return Text(result, style: const TextStyle(fontSize: 20));
  }

  // 建立城市選項
  Widget _buildCityOptions(
    BuildContext context,
    int? selectedItem,
    Widget? child,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: List.generate(MyHomePage.cities.length, (index) {
        return RadioListTile<int>(
          // 選項值
          value: index,

          // 目前選取值
          groupValue: selectedItem,

          // 城市名稱
          title: Text(
            MyHomePage.cities[index],

            style: const TextStyle(fontSize: 20),
          ),

          // 點選事件
          onChanged: (value) {
            // 更新選擇城市
            _selectedCity.value = value;
          },
        );
      }),
    );
  }
}
