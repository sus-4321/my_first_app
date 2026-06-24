import 'package:flutter/material.dart';
// 1. 這裡要對應你 D:\my_first_app 的專案名稱，並指向正確的 Helper 檔案名稱
import 'package:my_first_app/20260609_share_preferenes.helper.dart';

void main() {
  // App 啟動進入點
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo',
      debugShowCheckedModeBanner: false, // 隱藏右上角 DEBUG 條
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(), // 進入主頁面
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 建立文字輸入框的控制器
  final TextEditingController _nameController = TextEditingController();

  // 宣告一個用於包裝姓名、能局部重新渲染 UI 的 ValueNotifier
  final ValueNotifier<String> _name = ValueNotifier<String>('');

  // 2. 修正紅線核心：因為 Helper 限制了外部建立，這裡必須透過 .instance 來取得唯一的 Helper 實例
  final SharePreferencesHelper _helper = SharePreferencesHelper.instance;

  @override
  void dispose() {
    // 頁面關閉時釋放控制器資源，避免記憶體洩漏
    _nameController.dispose();
    _name.dispose();
    super.dispose();
  }

  // 觸發儲存動作
  Future<void> _saveName() async {
    await _helper.saveName(_nameController.text);
  }

  // 觸發讀取動作
  Future<void> _readName() async {
    final name = await _helper.readName();
    _name.value = name; // 更新數值，畫面會自動重繪
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('儲存資料')),
      body: Center(
        child: Column(
          children: [
            // 輸入框區塊
            Container(
              width: 200,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: '輸入姓名',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            // 儲存按鈕
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: _buildButton(text: '儲存', onPressed: _saveName),
            ),
            // 讀取按鈕
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: _buildButton(text: '讀取', onPressed: _readName),
            ),
            // 顯示結果區塊（自動監聽並更新）
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ValueListenableBuilder<String>(
                valueListenable: _name,
                builder: _nameWidgetBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 封裝的按鈕元件樣式
  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow, // 黃色背景
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // 圓角 6
        ),
        elevation: 8, // 陰影
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.redAccent), // 紅色文字
      ),
    );
  }

  // 負責渲染結果文字的 Builder 函數
  Widget _nameWidgetBuilder(BuildContext context, String name, Widget? child) {
    return Text(name, style: const TextStyle(fontSize: 20));
  }
}
