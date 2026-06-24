import 'package:flutter/material.dart';

// page_navigation_second_page.dart
// = 載入第二頁檔案
import 'package:my_first_app/20260519_second_page.dart';

// 主程式進入點
void main() {
  // runApp
  // = 啟動 Flutter App
  runApp(const MyApp());
}

// MyApp
// = App 最外層元件
class MyApp extends StatelessWidget {
  // 建構式
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp
    // = Flutter App 基本架構
    return MaterialApp(
      // title
      // = App 名稱
      title: '頁面切換範例',

      // debugShowCheckedModeBanner
      // = 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // theme
      // = App 主題設定
      theme: ThemeData(
        // primarySwatch
        // = App 主色
        primarySwatch: Colors.blue,
      ), // ThemeData
      // home
      // = App 首頁
      home: const MyHomePage(),
    ); // MaterialApp
  }
}

// MyHomePage
// = 第一頁畫面
class MyHomePage extends StatelessWidget {
  // 建構式
  const MyHomePage({super.key});

  // _openSecondPage
  // = 開啟第二頁
  void _openSecondPage(BuildContext context) {
    // Navigator.push
    // = 開啟新頁面
    Navigator.push(
      // context
      // = 畫面環境
      context,

      // MaterialPageRoute
      // = Flutter 頁面切換路由
      MaterialPageRoute(
        // builder
        // = 建立第二頁畫面
        builder: (context) => const SecondPage(),
      ), // MaterialPageRoute
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold
    // = App 頁面骨架
    return Scaffold(
      // appBar
      // = 上方工具列
      appBar: AppBar(
        // title
        // = AppBar 標題
        title: const Text(
          // 顯示文字
          '切換頁面',
        ), // Text
      ), // AppBar
      // body
      // = 頁面內容
      body: Center(
        // child
        // = 中間元件
        child: Padding(
          // padding
          // = 內距設定
          padding: const EdgeInsets.all(30),

          // child
          // = Padding 內元件
          child: ElevatedButton(
            // onPressed
            // = 按下按鈕事件
            onPressed: () => _openSecondPage(context),

            // child
            // = 按鈕文字
            child: const Text(
              // 顯示文字
              '開啟第二頁',

              // style
              // = 文字樣式
              style: TextStyle(
                // fontSize
                // = 字體大小
                fontSize: 18,
              ), // TextStyle
            ), // Text
          ), // ElevatedButton
        ), // Padding
      ), // Center
    ); // Scaffold
  }
}
