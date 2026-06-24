import 'package:flutter/material.dart';
// 1. 引入我們剛剛寫好的酷朋首頁檔案
import 'package:my_first_app/20260610_rocket_delivery_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '酷朋火箭速配',
      debugShowCheckedModeBanner: false, // 隱藏右上角的 DEBUG 側標
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // 使用現代化的 Material 3 設計風格
      ),
      // 2. 將首頁指定為我們開發的 RocketDeliveryHome
      home: const RocketDeliveryHome(),
    );
  }
}
