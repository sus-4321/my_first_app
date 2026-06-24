import 'package:flutter/material.dart';

// 應用程式的進入點
void main() {
  runApp(const MyApp());
}

// 應用程式根元件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer 範例',
      // 設定主題顏色為藍色
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          MyHomePage(), // 設定首頁（注意：這裡作者又用回了 StatelessWidget，搭配 ValueNotifier 運作）
    );
  }
}

// 首頁元件：使用 StatelessWidget 配合 ValueNotifier 達到局部刷新的高效能寫法
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // 1. 建立一個 ValueNotifier（數值通知器），用來儲存及監聽中央畫面的訊息文字
  final ValueNotifier<String> _msg = ValueNotifier<String>('');

  // 2. 定義靜態常數列表，存放側邊欄的所有選單文字
  static const List<String> _menuItems = ['選項一', '選項二', '選項三'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 頂部導覽列：當有設定 drawer 時，左側會自動出現漢堡選單按鈕
      appBar: AppBar(title: const Text('AppBar範例')),

      // 3. 定義側邊欄抽屜（Drawer）
      drawer: Drawer(
        child: ListView(
          children: [
            // 抽屜頂部藍色區塊
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Drawer標題',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ), // // DrawerHeader
            // 🌟 核心高階寫法：展開運算子（...）搭配 List.generate
            // List.generate 會根據資料長度（3）產生一個含有 3 個 ListTile 的獨立陣列。
            // 接著前面的三個點（...）會把這個新陣列「拆開」，將裡面的 ListTile 一個一個排進 children 大陣列中。
            ...List.generate(
              _menuItems.length, // 產生清單的數量
              (index) => ListTile(
                title: Text(
                  _menuItems[index], // 根據當前的索引值（0, 1, 2）抓出對應的文字
                  style: const TextStyle(fontSize: 20),
                ), // // Text
                onTap: () {
                  // 當使用者點擊該項目時
                  _msg.value = _menuItems[index]; // 1. 將中央文字更新為點選的項目名稱
                  Navigator.pop(context); // 2. 自動將側邊欄抽屜關閉（收回）
                },
              ), // // ListTile
            ), // // List.generate
          ],
        ), // // ListView
      ), // // Drawer
      // 4. 主畫面中央主體
      body: Center(
        child: ValueListenableBuilder<String>(
          valueListenable: _msg, // 監聽訊息通知器 _msg
          builder: _showMsg, // 當數值改變時，呼叫下方的 _showMsg 方法重新刷出文字
        ), // // ValueListenableBuilder
      ), // // Center
    ); // // Scaffold
  }

  // 5. 畫面中央文字的產生器（Builder）
  Widget _showMsg(BuildContext context, String msg, Widget? child) {
    return Text(msg, style: const TextStyle(fontSize: 20));
  }
}
