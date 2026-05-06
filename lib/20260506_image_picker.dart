import 'package:flutter/material.dart';
// Flutter 的 UI 套件
// 裡面有按鈕、文字、畫面、AppBar 等元件

import 'dart:io';
// Dart 的檔案功能
// 因為等等要用 File() 顯示手機照片

import 'package:image_picker/image_picker.dart';
// image_picker 套件
// 可以開啟手機相機與相簿


// =========================
// 程式開始執行的位置
// =========================
void main() {

  // runApp = 啟動 Flutter App
  runApp(const MyApp());
}



// =========================
// 整個 App 的外殼
// =========================
class MyApp extends StatelessWidget {

  // 建構子
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp = Flutter 基本應用程式框架
    return MaterialApp(

      // App 名稱
      title: 'Image Picker',

      // 右上角 DEBUG 標籤關閉
      debugShowCheckedModeBanner: false,

      // App 主題顏色
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      // App 一開始顯示的畫面
      home: const MyHomePage(),
    );
  }
}



// =========================
// 主畫面 StatefulWidget
// StatefulWidget = 畫面會改變
// 因為圖片會更新
// =========================
class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



// =========================
// 主畫面狀態管理
// =========================
class _MyHomePageState extends State<MyHomePage> {


  // =========================
  // 儲存圖片檔案
  // XFile? 表示：
  // 可以是圖片，也可以是 null
  // =========================
  final ValueNotifier<XFile?> _imageFile =
      ValueNotifier(null);


  // =========================
  // 建立 ImagePicker 物件
  // 之後要用它開啟相機與相簿
  // =========================
  final ImagePicker _imagePicker =
      ImagePicker();


  // =========================
  // 畫面關閉時執行
  // dispose = 清除記憶體
  // =========================
  @override
  void dispose() {

    // 釋放 ValueNotifier
    _imageFile.dispose();

    super.dispose();
  }



  // =========================
  // 建立畫面 UI
  // =========================
  @override
  Widget build(BuildContext context) {


    // =========================
    // 相機按鈕
    // =========================
    final btnCameraImage = ElevatedButton(

      // 按下按鈕時執行
      onPressed: () =>
          _getImage(ImageSource.camera),

      // 按鈕樣式
      style: ElevatedButton.styleFrom(

        // 背景顏色
        backgroundColor: Colors.greenAccent,

        // 內距
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),

        // 圓角
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
      ),

      // 按鈕文字
      child: const Text(

        '相機拍照',

        style: TextStyle(
          fontSize: 18,
          color: Colors.limeAccent,
        ),
      ),
    );



    // =========================
    // 相簿按鈕
    // =========================
    final btnGalleryImage = ElevatedButton(

      // 按下按鈕後
      onPressed: () =>
          _getImage(ImageSource.gallery),

      // 按鈕樣式
      style: ElevatedButton.styleFrom(

        backgroundColor:
            Colors.lightGreenAccent,

        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
      ),

      // 按鈕文字
      child: const Text(

        '挑選相簿照片',

        style: TextStyle(
          fontSize: 18,
          color: Colors.greenAccent,
        ),
      ),
    );



    // =========================
    // Scaffold
    // Flutter 頁面骨架
    // =========================
    return Scaffold(

      // 上方標題列
      appBar: AppBar(

        title: const Text('挑選照片'),

        // 標題置中
        centerTitle: true,
      ),



      // 頁面內容
      body: Column(

        children: [

          // 空白距離
          const SizedBox(height: 10),

          // 相機按鈕
          btnCameraImage,

          const SizedBox(height: 10),

          // 相簿按鈕
          btnGalleryImage,

          const SizedBox(height: 10),


          // Expanded = 撐滿剩餘空間
          Expanded(

            child: Center(

              // ValueListenableBuilder
              // 監聽 _imageFile 的變化
              child: ValueListenableBuilder<XFile?>(

                // 監聽物件
                valueListenable: _imageFile,

                // 當資料改變時
                // 自動更新畫面
                builder: _imageBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }



  // =========================
  // 取得圖片
  // source:
  // camera = 相機
  // gallery = 相簿
  // =========================
  Future<void> _getImage(
      ImageSource source) async {

    // 開啟相機或相簿
    final XFile? file =
        await _imagePicker.pickImage(
      source: source,
    );


    // 如果有選到圖片
    if (file != null) {

      // 更新圖片
      _imageFile.value = file;
    }
  }



  // =========================
  // 顯示圖片區域
  // =========================
  Widget _imageBuilder(

    BuildContext context,

    // 目前圖片
    XFile? imageFile,

    Widget? child,
  ) {


    // 如果沒有圖片
    if (imageFile == null) {

      // 顯示文字
      return const Text(

        '沒有照片',

        style: TextStyle(
          fontSize: 20,
        ),
      );
    }


    // =========================
    // 顯示圖片
    // =========================
    return Image.file(

      // File() 讀取圖片路徑
      File(imageFile.path),

      // 圖片縮放方式
      fit: BoxFit.contain,
    );
  }
}
