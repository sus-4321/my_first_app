import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          color: const Color.fromARGB(255, 88, 224, 9),
          margin: const EdgeInsets.all(20.0),
          
          padding: const EdgeInsets.all(50.0),
          
          child: const Text(
            "Riize App\nRise成長Realize實現",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFFFF0000),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
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
