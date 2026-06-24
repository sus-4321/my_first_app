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
      title: '對話盒範例',

      // 隱藏右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // 設定主題顏色
      theme: ThemeData(primarySwatch: Colors.blue),

      // 首頁
      home: const MyHomePage(),
    );
  }
}

// 首頁
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 儲存對話盒回傳結果
  final ValueNotifier<int?> _dialogResult = ValueNotifier<int?>(null);

  @override
  void dispose() {
    // 釋放記憶體
    _dialogResult.dispose();

    super.dispose();
  }

  // 顯示儲存確認對話盒
  Future<void> _showSaveDialog() async {
    // 等待使用者按下按鈕後回傳結果
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // 對話盒內容
          content: const Text('程式結束前是否要儲存檔案？'),

          // 內容邊距
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

          // 內容文字樣式
          contentTextStyle: const TextStyle(color: Colors.indigo, fontSize: 20),

          // 對話盒圓角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          actions: [
            // 是按鈕
            TextButton(
              onPressed: () => Navigator.pop(context, 1),

              child: const Text(
                '是',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),

            // 否按鈕
            TextButton(
              onPressed: () => Navigator.pop(context, 0),

              child: const Text(
                '否',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),

            // 取消按鈕
            TextButton(
              onPressed: () => Navigator.pop(context, -1),

              child: const Text(
                '取消',
                style: TextStyle(color: Colors.black45, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );

    // 將回傳結果存入 ValueNotifier
    _dialogResult.value = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 標題列
      appBar: AppBar(title: const Text('對話盒範例')),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // 顯示對話盒按鈕
            ElevatedButton(
              onPressed: _showSaveDialog,

              child: const Text('顯示對話盒', style: TextStyle(fontSize: 20)),
            ),

            // 間隔 20 像素
            const SizedBox(height: 20),

            // 顯示對話盒回傳結果
            ValueListenableBuilder<int?>(
              valueListenable: _dialogResult,

              builder: (context, result, child) {
                return Text(
                  result?.toString() ?? '',
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
