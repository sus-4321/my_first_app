// ignore: file_names
import 'package:flutter/material.dart'; // Flutter 原生 UI 元件庫
import 'package:my_first_app/20260401_app_body.dart'; // 第三方套件，用來顯示 Toast 訊息

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
      body: const AppBody(        
      ),
    );
  }
}

