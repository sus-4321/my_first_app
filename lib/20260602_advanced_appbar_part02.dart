import 'package:flutter/material.dart';

// 應用程式的進入點
void main() {
  runApp(const MyApp());
}

// 應用程式的根元件（Root Widget）
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer範例',
      // 隱藏畫面右上角的 debug 紅色布條
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // 設定主要佈景顏色為藍色
      ),
      home: const MyHomePage(), // 設定首頁
    );
  }
}

// 首頁元件：因為需要動態更換中央的文字，使用有狀態元件（StatefulWidget）
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 負責處理 MyHomePage 的畫面與狀態變更
class _MyHomePageState extends State<MyHomePage> {
  // 1. 建立一個 ValueNotifier（數值通知器）
  // 負責記錄並通知「目前主畫面中央要顯示的文字」，初始值為 '請選擇 Drawer 選單'
  final ValueNotifier<String> _messageNotifier = ValueNotifier<String>(
    '請選擇 Drawer 選單',
  );

  @override
  void dispose() {
    // 當畫面被銷毀時，一定要釋放 ValueNotifier，以免佔用記憶體（Memory Leak）
    _messageNotifier.dispose();
    super.dispose();
  }

  // 2. 當使用者點擊側邊欄項目時，觸發此方法
  void _selectMenu(String menu) {
    _messageNotifier.value = menu; // 更新數值，這會觸發 ValueListenableBuilder 刷新畫面文字
    Navigator.pop(context); // 關鍵！自動關閉（收回）目前開啟的側邊欄
  }

  // 3. 自訂一個用來快速建立「側邊欄項目」的方法
  Widget _buildDrawerItem(String title) {
    return ListTile(
      // ListTile 是清單項目元件，特別適合放在選單內
      title: Text(title, style: const TextStyle(fontSize: 20)),
      onTap: () => _selectMenu(title), // 點擊時，呼叫上面定義的 _selectMenu 方法並帶入標題
    ); // // ListTile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 頂部導覽列：當 Scaffold 偵測到有設定 drawer 時，會自動在左側加上「三條線 (Menu)」的按鈕
      appBar: AppBar(title: const Text('Drawer範例')),

      // 4. 定義側邊欄抽屜（Drawer）
      drawer: Drawer(
        child: ListView(
          // 使用 ListView 確保當選項太多時可以上下滾動，避免畫面溢出
          children: [
            // 抽屜的藍色頂部區塊（通常用來放使用者大頭貼或系統名稱）
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Drawer標題',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ), // // DrawerHeader
            // 使用自訂的方法產生三個選單項目
            _buildDrawerItem('選項一'),
            _buildDrawerItem('選項二'),
            _buildDrawerItem('選項三'),
          ],
        ),
      ), // // Drawer
      // 5. 主畫面中央主體
      body: Center(
        child: ValueListenableBuilder<String>(
          valueListenable: _messageNotifier, // 緊緊盯著訊息通知器
          builder: (context, value, child) {
            // 當 _messageNotifier.value 改變時，這裡會單獨重新渲染
            return Text(value, style: const TextStyle(fontSize: 24));
          },
        ), // // ValueListenableBuilder
      ), // // Center
    ); // // Scaffold
  }
}
