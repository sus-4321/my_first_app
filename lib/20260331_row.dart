// ignore: file_names
import 'package:flutter/material.dart' show AppBar, BuildContext, Color, Colors, Container, CrossAxisAlignment, EdgeInsets, Expanded, MainAxisAlignment, MaterialApp, Matrix4, Row, Scaffold, StatelessWidget, Text, TextStyle, Widget, runApp; // Flutter 原生 UI 元件庫


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
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "Hello Riize!!",
          style: TextStyle(backgroundColor: Color(0xFF00FF00)),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        color: Colors.cyanAccent,
        height: 300.0,
        width: 300.0,
        transform: Matrix4.rotationZ(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Expanded(
              flex: 2,
              child: const Text(
                "Riize01",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepOrange,
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: const Text(
                "Riize02",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepOrange,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            const Text(
              "Riize03",
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrange,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
myApp
 |__MaterialApp
      |__myHomePage
          |__Scaffold
                |__AppBar
                    |__Title
                        |__Text
                |__Body
                    |__Center
                        |__Text
*/

/*
Image.asset - 載入本地端圖片

Image.network - 載入網路圖片

Image.file - 載入裝置端圖片
*/
