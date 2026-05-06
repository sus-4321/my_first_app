import 'dart:io';
// dart:io
// File() 讀取手機圖片檔案時要用

import 'package:flutter/material.dart';
// Flutter UI 元件庫
// 例如：按鈕、文字、AppBar、GridView

import 'package:image_picker/image_picker.dart';
// image_picker 套件
// 可以開啟手機相機與相簿

// =====================================================
// main()
// Flutter 程式開始執行的位置
// =====================================================
void main() {

  // 啟動 App
  runApp(const MyApp());
}

// =====================================================
// MyApp
// 整個 App 外層
// StatelessWidget = 畫面不會改變
// =====================================================
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(

      // 首頁
      home: MyHomePage(),
    );
  }
}

// =====================================================
// StatefulWidget
// 因為圖片會改變
// 所以使用 StatefulWidget
// =====================================================
class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState();
}

// =====================================================
// 畫面狀態管理
// =====================================================
class _MyHomePageState
    extends State<MyHomePage> {

  // =====================================================
  // ValueNotifier<List<XFile>>
  //
  // ValueNotifier:
  // 用來通知畫面更新
  //
  // List<XFile>:
  // 多張圖片清單
  //
  // []:
  // 一開始是空陣列
  // =====================================================
  final ValueNotifier<List<XFile>>
      _imageFiles = ValueNotifier([]);

  // =====================================================
  // ImagePicker 物件
  //
  // 用來：
  // 1. 開啟相機
  // 2. 開啟相簿
  // =====================================================
  final ImagePicker _imagePicker =
      ImagePicker();

  // =====================================================
  // dispose()
  //
  // 畫面關閉時執行
  // 清除記憶體
  // =====================================================
  @override
  void dispose() {

    // 釋放 notifier
    _imageFiles.dispose();

    super.dispose();
  }

  // =====================================================
  // build()
  //
  // 建立整個畫面 UI
  // =====================================================
  @override
  Widget build(BuildContext context) {

    // =====================================================
    // 相機按鈕
    // =====================================================
    final btnCameraImage = ElevatedButton(

      // 按下按鈕後執行
      onPressed: _takePicture,

      // 按鈕樣式
      style: ElevatedButton.styleFrom(

        // 背景顏色
        backgroundColor: Colors.blue,

        // 內距
        padding: const EdgeInsets.symmetric(
          vertical: 10,
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
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );

    // =====================================================
    // 相簿按鈕
    // =====================================================
    final btnGalleryImage = ElevatedButton(

      // 按下後執行
      onPressed: _selectImages,

      style: ElevatedButton.styleFrom(

        backgroundColor: Colors.blue,

        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
      ),

      child: const Text(

        '挑選相簿照片',

        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );

    // =====================================================
    // Scaffold
    //
    // Flutter 頁面骨架
    // =====================================================
    return Scaffold(

      // 上方標題列
      appBar: AppBar(

        title: const Text('挑選照片'),
      ),

      // 畫面內容
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

          // Expanded
          // 撐滿剩餘空間
          Expanded(

            child:
                ValueListenableBuilder<
                    List<XFile>>(

              // 監聽圖片清單
              valueListenable: _imageFiles,

              // 當圖片改變時
              // 自動更新畫面
              builder: _imageBuilder,
            ),
          ),
        ],
      ),
    );
  }
  // =====================================================
  // _takePicture()
  //
  // 開啟相機拍照
  // =====================================================
  Future<void> _takePicture() async {

    // pickImage()
    // 開啟相機
    final XFile? photo =
        await _imagePicker.pickImage(

      // 使用相機
      source: ImageSource.camera,
    );

    // 如果有拍到照片
    if (photo != null) {
      // [photo]
      // 把單張照片放進 List
      _imageFiles.value = [photo];
    }
  }
  // =====================================================
  // _selectImages()
  //
  // 從相簿挑選多張照片
  // =====================================================
  Future<void> _selectImages() async {


    // pickMultiImage()
    // 可一次選多張圖片
    final List<XFile>? files =
        await _imagePicker.pickMultiImage();

    // 如果有選到圖片
    if (files != null &&
        files.isNotEmpty) {

      // 更新圖片清單
      _imageFiles.value = files;
    }
  }
  // =====================================================
  // _imageBuilder()
  //
  // 顯示圖片區域
  // =====================================================
  Widget _imageBuilder(

    BuildContext context,

    // 圖片清單
    List<XFile> imageFiles,

    Widget? child,
  ) {

    // =====================================================
    // 如果沒有照片
    // =====================================================
    if (imageFiles.isEmpty) {

      return const Center(

        child: Text(

          '沒有照片',

          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }

    // =====================================================
    // GridView.builder
    //
    // 網格式圖片排列
    // =====================================================
    return GridView.builder(

      // GridView 內距
      padding: const EdgeInsets.all(20),

      // 滑動效果
      physics:
          const BouncingScrollPhysics(),

      // 網格設定
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

        // 一列 2 張
        crossAxisCount: 2,

        // 左右間距
        crossAxisSpacing: 20,

        // 上下間距
        mainAxisSpacing: 20,
      ),

      // 圖片數量
      itemCount: imageFiles.length,

      // 建立每一張圖片
      itemBuilder: (context, index) {

        return ClipRRect(

          // 圓角
          borderRadius:
              BorderRadius.circular(10),

          child: Image.file(

            // File()
            // 讀取圖片路徑
            File(
              imageFiles[index].path,
            ),

            // cover
            // 自動填滿容器
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
