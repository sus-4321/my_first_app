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
      // 隱藏畫面上方的 debug 標籤
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 使用 Material 3 設計規範（新版 Flutter 的標準外觀）
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(), // 設定首頁
    );
  }
}

// 首頁元件
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 負責管理 MyHomePage 的畫面與狀態
class _MyHomePageState extends State<MyHomePage> {
  // 1. 建立一個 ValueNotifier（數值通知器）
  // 負責記錄並通知「目前畫面中央要顯示的文字」，初始值為 '請從左側選單選擇項目'
  final ValueNotifier<String> _msg = ValueNotifier<String>('請從左側選單選擇項目');

  // 2. 定義一個靜態常數清單，存放所有的選單選項名稱
  // 未來如果想增加「選項四」，只需要直接在這個 List 裡面加字串就好，畫面會自動適應！
  final List<String> _menuItems = const ['選項一', '選項二', '選項三'];

  @override
  void dispose() {
    // 當畫面被銷毀時，一定要釋放 ValueNotifier，以免佔用記憶體（Memory Leak）
    _msg.dispose();
    super.dispose();
  }

  // 3. 當使用者點擊選單項目時，觸發此方法
  void _selectMenuItem(String item) {
    _msg.value = item; // 更新變數數值（中央文字會跟著動）
    Navigator.pop(context); // 自動關閉（收回）左側滑出的選單
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 頂部導覽列：當設定 drawer 時，系統會自動在左側加上漢堡選單（三條線）按鈕
      appBar: AppBar(title: const Text('Drawer 範例')),

      // 4. 定義側邊欄抽屜（Drawer）
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // 清除 ListView 預設的頂部內邊距，讓藍色區塊可以完美貼頂
          children: [
            // 側邊欄抽屜的頂部藍色區塊
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Drawer 標題',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ), // // DrawerHeader
            // 🌟 核心高階寫法：UI 內部的 For 迴圈（Collection for）
            // 程式會自動遍歷 _menuItems 清單（選項一、二、三）
            // 每繞一圈，就會自動產生一個對應的 ListTile 塞進 children 陣列中
            for (final item in _menuItems)
              ListTile(
                title: Text(item, style: const TextStyle(fontSize: 20)),
                onTap: () => _selectMenuItem(item), // 點擊時，把目前的項目名稱帶入方法
              ), // // ListTile
          ],
        ), // // ListView
      ), // // Drawer
      // 5. 主畫面中央主體
      body: Center(
        child: ValueListenableBuilder<String>(
          valueListenable: _msg, // 緊緊盯著訊息通知器 _msg
          builder: (context, msg, child) {
            // 當 _msg.value 改變時，這裡會被單獨觸發，重新刷出大字體文字（size: 20）
            return Text(msg, style: const TextStyle(fontSize: 20));
          },
        ), // // ValueListenableBuilder
      ), // // Center
    ); // // Scaffold
  }
}
