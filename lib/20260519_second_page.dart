import 'package:flutter/material.dart';

// SecondPage
// = 第二頁畫面
class SecondPage extends StatelessWidget {
  // 建構式
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold
    // = 頁面骨架
    return Scaffold(
      // appBar
      // = 上方工具列
      appBar: AppBar(
        // title
        // = 標題文字
        title: const Text('第二頁'),

        // backgroundColor
        // = AppBar 顏色
        backgroundColor: Colors.amber,
      ),

      // backgroundColor
      // = 背景顏色
      backgroundColor: const Color(0xFFFCDCDC),

      // body
      // = 頁面內容
      body: Center(
        // child
        // = 中間元件
        child: Padding(
          // padding
          // = 內距
          padding: const EdgeInsets.all(30),

          // child
          // = Padding 內元件
          child: ElevatedButton(
            // onPressed
            // = 按鈕點擊事件
            onPressed: () => Navigator.pop(context),

            // child
            // = 按鈕文字
            child: const Text('回到上一頁'),
          ), // ElevatedButton
        ), // Padding
      ), // Center
    ); // Scaffold
  }
}
