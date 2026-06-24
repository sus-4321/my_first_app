import 'package:flutter/material.dart';

// 應用程式進入點
void main() {
  runApp(const MyApp());
}

// 應用程式根元件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppBar範例',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 主題顏色設為藍色
      ),
      home: MyHomePage(), // 設定首頁
    );
  }
}

// 首頁元件：這裡很有趣，雖然畫面內容會變，但它繼承了「StatelessWidget」（無狀態元件）
// 這是因為它把狀態管理交給了 ValueNotifier，不需要依賴傳統的 StatefulWidget 與 setState
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // 建立一個 ValueNotifier（數值通知器）
  // 專門用來記錄「目前畫面上要顯示的提示訊息字串」，初始值為空字串 ''
  final ValueNotifier<String> _msg = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    // 1. 定義右側的第一個按鈕：手機圖標按鈕（IconButton）
    final phoneButton = IconButton(
      icon: const Icon(Icons.phone_android, color: Colors.white),
      onPressed: () {
        // 當按鈕被點擊時，修改 _msg 的值
        _msg.value = '你按下手機按鈕';
      },
    ); // // IconButton

    // 2. 定義右側的第二個按鈕：彈出式選單按鈕（PopupMenuButton）
    final popupMenu = PopupMenuButton<int>(
      // itemBuilder 用來構建彈出選單裡面的項目列表
      itemBuilder: (context) => const [
        // 選單第一項
        PopupMenuItem<int>(
          value: 1, // 這個項目的代號/數值
          child: Text('第一項', style: TextStyle(fontSize: 20)),
        ), // // PopupMenuItem
        // 選單分隔線
        PopupMenuDivider(),

        // 選單第二項
        PopupMenuItem<int>(
          value: 2, // 這個項目的代號/數值
          child: Text('第二項', style: TextStyle(fontSize: 20)),
        ), // // PopupMenuItem
      ],
      // 当使用者點選了選單中的某一項時觸發
      onSelected: (value) {
        // 使用 switch 判斷使用者點選的是哪一個 value
        switch (value) {
          case 1:
            _msg.value = '第一項';
            break;
          case 2:
            _msg.value = '第二項';
            break;
        }
      },
    ); // // PopupMenuButton

    // 3. 構建頂部導覽列（AppBar）
    final appBar = AppBar(
      title: const Text('AppBar範例'),
      // automaticallyImplyLeading 代表是否讓系統自動生成返回按鈕
      // 設為 false 表示我們要完全「自訂」左側的按鈕，不讓系統插手
      automaticallyImplyLeading: false,

      // leading 代表 AppBar 左側的區塊（通常用來放返回鍵或側邊欄選單鈕）
      leading: InkWell(
        // InkWell 是一個點擊時會產生「水波紋效果」的互動元件
        onTap: () {
          _msg.value = '你按下選單按鈕';
        },
        child: const Icon(Icons.menu), // 使用內建的三條線選單圖標
      ), // // InkWell
      // actions 代表 AppBar 右側的功能按鈕清單（接受一個 Widget 陣列）
      actions: [phoneButton, popupMenu],
    ); // // AppBar

    // 4. 組裝頁面骨架並返回
    return Scaffold(
      appBar: appBar, // 頂部導覽列
      body: ValueListenableBuilder<String>(
        valueListenable: _msg, // 監聽訊息變數
        builder: _showMsg, // 當訊息改變時，呼叫下方的 _showMsg 方法重新渲染畫面
      ),
    ); // // Scaffold
  }

  // 畫面中央文字的產生器（Builder）
  // 參數中的 msg 會由 ValueListenableBuilder 自動將最新的 _msg.value 帶入
  Widget _showMsg(BuildContext context, String msg, Widget? child) {
    return Center(
      child: Text(
        msg,
        style: const TextStyle(fontSize: 20), // 設定字型大小為 20
      ),
    );
  }
}
