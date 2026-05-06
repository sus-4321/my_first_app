// 匯入 dart:io
// File 類別在這裡，等等 Image.file() 會用到
import 'dart:io';

// Flutter 基本 UI 套件
// MaterialApp、Scaffold、AppBar、Text 等元件都在這裡
import 'package:flutter/material.dart';

// 圖片選擇套件
// 可以從手機相簿選圖片
import 'package:image_picker/image_picker.dart';


// =========================
// 程式進入點 main()
// Flutter 程式從這裡開始執行
// =========================
void main() {

  // runApp() 啟動 Flutter App
  // const MyApp() 表示執行 MyApp 這個 Widget
  runApp(const MyApp());
}


// =======================================================
// MyApp
// 整個 Flutter App 最外層
// StatelessWidget = 畫面不會自己改變
// =======================================================
class MyApp extends StatelessWidget {

  // 建構子
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp 是 Flutter 的基本 App 架構
    // home: 指定首頁畫面
    return const MaterialApp(

      // 首頁畫面
      home: MyHomePage(),
    );
  }
}


// =======================================================
// MyHomePage
// StatefulWidget = 畫面資料會改變
// 因為圖片會新增，所以要用 StatefulWidget
// =======================================================
class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override

  // createState()
  // 建立真正控制畫面的 State 類別
  State<MyHomePage> createState() => _MyHomePageState();
}



// =======================================================
// _MyHomePageState
// 真正控制畫面資料與功能的地方
// =======================================================
class _MyHomePageState extends State<MyHomePage> {
  

  // ===================================================
  // ValueNotifier<List<XFile>>
  //
  // 用來儲存圖片清單
  //
  // XFile:
  // image_picker 選出來的圖片型態
  //
  // []:
  // 一開始是空陣列
  // ===================================================
  final ValueNotifier<List<XFile>> _imageFiles =
      ValueNotifier([]);




  // ===================================================
  // ImagePicker 物件
  //
  // 用來開啟手機相簿
  // ===================================================
  final ImagePicker _imagePicker = ImagePicker();




  // ===================================================
  // dispose()
  //
  // Widget 被銷毀時會執行
  //
  // ValueNotifier 用完要釋放記憶體
  // ===================================================
  @override
  void dispose() {

    // 釋放 _imageFiles
    _imageFiles.dispose();

    // 執行父類別 dispose()
    super.dispose();
  }




  // ===================================================
  // build()
  //
  // Flutter 每次更新畫面都會重新執行 build()
  // ===================================================
  @override
  Widget build(BuildContext context) {

    // =================================================
    // ElevatedButton 按鈕
    // =================================================
    final btnPickImages = ElevatedButton(

      // 按下按鈕時執行 _pickImages()
      onPressed: _pickImages,

      // 按鈕文字
      child: const Text('選擇圖片'),
    );



    // =================================================
    // Scaffold
    //
    // Flutter 頁面骨架
    // 有 AppBar、body 等
    // =================================================
    return Scaffold(

      // 上方標題列
      appBar: AppBar(

        // AppBar 標題
        title: const Text('GridView圖片範例'),
      ),




      // =================================================
      // body
      // 頁面主要內容
      // =================================================
      body: Column(

        // Column = 垂直排列
        children: [

          // 上方空白 10
          const SizedBox(height: 10),

          // 選圖按鈕
          btnPickImages,

          // 下方空白 10
          const SizedBox(height: 10),



          // =================================================
          // Expanded
          //
          // 讓下面 GridView 撐滿剩餘空間
          // =================================================
          Expanded(

            child:

                // =========================================
                // ValueListenableBuilder
                //
                // 監聽 _imageFiles
                //
                // 當圖片改變時，自動刷新畫面
                // =========================================
                ValueListenableBuilder<List<XFile>>(

              // 要監聽的資料
              valueListenable: _imageFiles,



              // builder:
              // 當資料變化時會重新執行
              builder: (context, images, _) {

                // =====================================
                // 如果沒有圖片
                // =====================================
                if (images.isEmpty) {

                  // 顯示文字
                  return const Center(
                    child: Text('尚未選擇圖片'),
                  );
                }



                // =====================================
                // GridView.builder
                //
                // 用格子方式顯示圖片
                // =====================================
                return GridView.builder(

                  // GridView 四周留白
                  padding: const EdgeInsets.all(20),

                  // 滑動效果
                  physics: const BouncingScrollPhysics(),




                  // ===================================
                  // gridDelegate
                  //
                  // 設定 GridView 排版
                  // ===================================
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                    // 一列顯示 2 張圖片
                    crossAxisCount: 2,

                    // 左右間距
                    crossAxisSpacing: 20,

                    // 上下間距
                    mainAxisSpacing: 20,
                  ),




                  // ===================================
                  // itemCount
                  //
                  // 圖片總數
                  // ===================================
                  itemCount: images.length,




                  // ===================================
                  // itemBuilder
                  //
                  // 每一格要長什麼樣子
                  // ===================================
                  itemBuilder: (context, index) {

                    return ClipRRect(

                      // 圓角
                      borderRadius: BorderRadius.circular(10),




                      // =================================
                      // Image.file
                      //
                      // 顯示本機圖片
                      // =================================
                      child: Image.file(

                        // File()
                        // 把圖片路徑轉成 File 物件
                        File(images[index].path),

                        // cover:
                        // 圖片填滿格子
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }






  // ===================================================
  // _pickImages()
  //
  // 選擇多張圖片
  // ===================================================
  Future<void> _pickImages() async {

    // =================================================
    // await
    //
    // 等待使用者選完圖片
    // =================================================
    final List<XFile>? files =
        await _imagePicker.pickMultiImage();




    // =================================================
    // 如果有選到圖片
    // =================================================
    if (files != null && files.isNotEmpty) {

      // 更新圖片資料

      // value:
      // ValueNotifier 裡面的值
      _imageFiles.value = files;
    }
  }
}