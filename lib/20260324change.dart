import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello Flutter!!",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 255, 255),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override // 必須移到類別內部
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rise Realize!!",
          style: TextStyle(backgroundColor: Color(0xFF00FF00), fontSize: 30),
        ),
      ),
      body: Center(
        child:
        Image.asset("assets/images/riize10.jpg"),     
            // Image.network(
            //   "https://www.ticketbuynow.com/wp-content/uploads/2025/05/riize9.png",
            //   ), 
      ),   
    );
  }
}
// height: 200, // 建議給圖片一個高度以防跑版
            
            // const SizedBox(height: 20), // 增加圖片與文字間的間距
            // const Text(
            //   "Riize",
            //   style: TextStyle(
            //     backgroundColor: Color.fromARGB(255, 212, 235, 8),
            //     fontSize: 60,
              
            