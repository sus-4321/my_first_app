// ignore: file_names
import 'package:flutter/material.dart'; // Flutter 原生 UI 元件庫
import 'package:fluttertoast/fluttertoast.dart'; // 第三方套件，用來顯示 Toast 訊息

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(title: "Hello Riize!!", home: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void showToast() {
  Fluttertoast.showToast(
    msg: "你按了按鈕", // 彈出的文字內容
    toastLength: Toast.LENGTH_LONG, // 訊息顯示的時間長度（LONG 約 3.5 秒）
    gravity: ToastGravity.CENTER,    // 訊息彈出的位置（畫面的正中央）
    backgroundColor: Colors.blue,   // Toast 的背景顏色
    textColor: Colors.white,        // Toast 的文字顏色
    fontSize: 20.0,                // 文字大小
  );
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "Hello Riize!!",
          style: TextStyle(backgroundColor: Color(0xFF00FF00)),
        ),
      ),
      body: Center(child: Container(
        padding: const EdgeInsets.all(30.0),
        child: ElevatedButton(
          onPressed: showToast,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            elevation: 8.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0),
          ),
        
child: const Text(
  "按我有禮品哦",
  style: TextStyle(
    fontSize: 20.0,
    color: Colors.purple,
  ),
),
      )
      )
      ),
    );
  }
}

