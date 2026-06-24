// Flutter Material UI 套件
import 'package:flutter/material.dart';

// 匯入飲料選擇頁
import 'package:my_first_app/20260526_order_select_drink.dart';

// 匯入主餐選擇頁
import 'package:my_first_app/20260526_order_select_main_course.dart';

// Flutter 程式入口
void main() {
  // 啟動 App
  runApp(const MyApp());
}

// App 主架構
class MyApp extends StatelessWidget {
  // 建構子
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 為整個 App 根元件
    return MaterialApp(
      // App 名稱
      title: '點餐系統',

      // 關閉右上角 debug 標籤
      debugShowCheckedModeBanner: false,

      // App 主題色
      theme: ThemeData(primarySwatch: Colors.blue),

      // 預設首頁
      initialRoute: '/',

      // 路由設定
      routes: {
        // 首頁
        '/': (context) => const MyHomePage(),

        // 主餐頁
        '/select-main-course': (context) => SelectMainCourse(),

        // 飲料頁
        '/select-drink': (context) => SelectDrink(),
      },
    );
  }
}

// 首頁 StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 首頁 State
class _MyHomePageState extends State<MyHomePage> {
  // 記錄目前選擇的主餐
  final ValueNotifier<String> _selectedMainCourse = ValueNotifier<String>(
    '尚未選擇主餐',
  );

  // 記錄目前選擇的飲料
  final ValueNotifier<String> _selectedDrink = ValueNotifier<String>('尚未選擇飲料');

  @override
  void dispose() {
    // 釋放記憶體
    _selectedMainCourse.dispose();

    _selectedDrink.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 上方標題列
      appBar: AppBar(title: const Text('點餐系統')),

      body: Padding(
        // 四周內距
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // 主餐區塊
            _buildSelectionRow(
              // 顯示主餐資料
              valueNotifier: _selectedMainCourse,

              // 按鈕文字
              buttonText: '選擇主餐',

              // 按鈕事件
              onPressed: () => _showMainCourseScreen(context),
            ),

            // 間距
            const SizedBox(height: 20),

            // 飲料區塊
            _buildSelectionRow(
              // 顯示飲料資料
              valueNotifier: _selectedDrink,

              // 按鈕文字
              buttonText: '選擇飲料',

              // 按鈕事件
              onPressed: () => _showDrinkScreen(context),
            ),
          ],
        ),
      ),
    );
  }

  // 共用選擇區塊
  Widget _buildSelectionRow({
    // 監聽資料
    required ValueNotifier<String> valueNotifier,

    // 按鈕文字
    required String buttonText,

    // 按鈕事件
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        // 自動填滿剩餘空間
        Expanded(
          child: ValueListenableBuilder<String>(
            // 監聽 ValueNotifier
            valueListenable: valueNotifier,

            // 當資料變更時自動刷新
            builder: (context, value, child) {
              return Text(
                // 顯示資料
                value,

                // 文字樣式
                style: const TextStyle(fontSize: 20),
              );
            },
          ),
        ),

        // 左右間距
        const SizedBox(width: 16),

        // 按鈕
        ElevatedButton(
          // 點擊事件
          onPressed: onPressed,

          // 按鈕樣式
          style: ElevatedButton.styleFrom(
            // 背景色
            backgroundColor: Colors.yellow,

            // 文字色
            foregroundColor: Colors.red,

            // 內距
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),

            // 陰影高度
            elevation: 8,
          ),

          // 按鈕文字
          child: Text(buttonText, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  // 顯示主餐頁面
  Future<void> _showMainCourseScreen(BuildContext context) async {
    // 等待主餐頁回傳資料
    final result = await Navigator.pushNamed(context, '/select-main-course');

    // 更新主餐資料
    _selectedMainCourse.value = result?.toString() ?? '沒有選擇主餐';
  }

  // 顯示飲料頁面
  Future<void> _showDrinkScreen(BuildContext context) async {
    // 等待飲料頁回傳資料
    final result = await Navigator.pushNamed(context, '/select-drink');

    // 更新飲料資料
    _selectedDrink.value = result?.toString() ?? '沒有選擇飲料';
  }
}
