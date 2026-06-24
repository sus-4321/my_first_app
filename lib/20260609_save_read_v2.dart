import 'package:flutter/material.dart';
// 【關鍵點】這裡必須精準指向你剛剛建立的「新 Helper 檔案名稱」
import 'package:my_first_app/20260609_share_preferences_helper_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo V2',
      debugShowCheckedModeBanner: false, // 隱藏右上角 DEBUG 條
      theme: ThemeData(
        // 自動生成佈景主題色彩
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
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

  // 建立局部重新渲染 UI 的 ValueNotifier
  final ValueNotifier<String> _name = ValueNotifier<String>('');

  // 正確呼叫新 Helper 檔案裡的單例實例
  final SharePreferencesHelperV2 _helper = SharePreferencesHelperV2.instance;

  // 【優化】加入 initState 函數，讓頁面「一載入」就自動去本地端讀取舊資料
  @override
  void initState() {
    super.initState();
    _readName(); // 初始自動讀取
  }

  @override
  void dispose() {
    // 頁面銷毀時釋放控制器，避免記憶體洩漏
    _nameController.dispose();
    _name.dispose();
    super.dispose();
  }

  // 觸發儲存
  Future<void> _saveName() async {
    await _helper.saveName(_nameController.text);
    // 【體驗優化】儲存成功後同步更新下方文字，不用逼使用者再點一次讀取
    _name.value = _nameController.text;
  }

  // 觸發讀取
  Future<void> _readName() async {
    final name = await _helper.readName();
    _name.value = name;
    // 【體驗優化】把讀出來的舊資料自動塞進輸入框，方便使用者直接修改
    _nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    // 【體驗優化】用 GestureDetector 包裹，點擊畫面任何空白處都能自動收起鍵盤
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('儲存資料 V2 (優化版)'),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.inversePrimary, // 導覽列顏色跟隨佈景主題
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 讓所有元件在畫面上垂直居中，視覺比例更美
            children: [
              // 輸入框區塊
              Container(
                width: 250, // 稍微加寬，視覺比例更舒適
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: '輸入姓名',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(), // 加上精美的圓角外框線
                  ),
                ),
              ),
              // 儲存按鈕
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildButton(text: '儲存資料', onPressed: _saveName),
              ),
              // 讀取按鈕
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _buildButton(text: '讀取舊資料', onPressed: _readName),
              ),
              const SizedBox(height: 25), // 留白間距
              // 顯示結果區塊
              const Text(
                '目前儲存的姓名：',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ValueListenableBuilder<String>(
                  valueListenable: _name,
                  builder: _nameWidgetBuilder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 封裝的按鈕元件樣式方法
  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow, // 黃色背景
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ), // 微調寬高襯托文字
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 圓角調整為 8，更具現代設計感
        ),
        elevation: 4, // 稍微降低原本過重的陰影，看起來更精緻
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 負責渲染結果文字的 Builder 函數
  Widget _nameWidgetBuilder(BuildContext context, String name, Widget? child) {
    // 如果本地端完全沒有資料，顯示提示警語
    if (name.isEmpty) {
      return const Text(
        '暫無資料',
        style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }
    // 有資料時，顯示漂亮的藍色粗體字
    return Text(
      name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
