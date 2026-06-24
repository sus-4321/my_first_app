// ======================================================
// Flutter Material UI 套件
// ======================================================
// Flutter 最常用 UI 套件
//
// 裡面有：
// MaterialApp
// Scaffold
// AppBar
// Text
// Button
// Colors
// Center
// 等等
// ======================================================
import 'package:flutter/material.dart';

// ======================================================
// main()
// ======================================================
// Flutter 程式入口
//
// App 啟動時
// 第一個執行這裡
// ======================================================
void main() {
  // runApp()
  // 啟動 Flutter App
  runApp(const MyApp());
}

// ======================================================
// MyApp
// ======================================================
// App 最外層
//
// StatelessWidget
// = 無狀態元件
// ======================================================
class MyApp extends StatelessWidget {
  // 建構子 constructor
  const MyApp({super.key});

  // ====================================================
  // build()
  // ====================================================
  // 建立畫面
  // ====================================================
  @override
  Widget build(BuildContext context) {
    // MaterialApp
    // Flutter App 主架構
    return MaterialApp(
      // App 名稱
      title: '動畫範例',

      // 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // 主題設定
      theme: ThemeData(
        // App 主顏色
        primarySwatch: Colors.blue,
      ),

      // 首頁
      home: const MyHomePage(),
    );
  }
}

// ======================================================
// MyHomePage
// ======================================================
// StatefulWidget
// = 有狀態元件
//
// 因為畫面會變化
// 所以使用 StatefulWidget
// ======================================================
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // ====================================================
  // createState()
  // ====================================================
  // 建立 State 狀態控制物件
  // ====================================================
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ======================================================
// _MyHomePageState
// ======================================================
// 真正控制畫面的地方
// ======================================================
class _MyHomePageState extends State<MyHomePage> {
  // ====================================================
  // ValueNotifier<double>
  // ====================================================
  // ValueNotifier
  // = 資料變化通知器
  //
  // <double>
  // = 小數型態
  //
  // opacity
  // = 透明度
  //
  // 1.0 = 完全看得到
  // 0.0 = 完全透明
  // ====================================================
  final ValueNotifier<double> _opacity = ValueNotifier(1.0);

  // ====================================================
  // dispose()
  // ====================================================
  // 元件銷毀時執行
  //
  // 釋放記憶體
  // ====================================================
  @override
  void dispose() {
    // 釋放 ValueNotifier
    _opacity.dispose();

    super.dispose();
  }

  // ====================================================
  // _changeOpacity()
  // ====================================================
  // 改變透明度
  // ====================================================
  void _changeOpacity() {
    // 修改透明度
    //
    // 0.0
    // = 完全透明
    _opacity.value = 0.0;
  }

  // ====================================================
  // build()
  // ====================================================
  // 建立畫面
  // ====================================================
  @override
  Widget build(BuildContext context) {
    // Scaffold
    // Flutter 頁面骨架
    return Scaffold(
      // ==================================================
      // AppBar
      // ==================================================
      // 上方標題列
      appBar: AppBar(
        // 標題文字
        title: const Text('動畫範例'),
      ),

      // ==================================================
      // body
      // ==================================================
      // 頁面主要內容
      body: Center(
        // ==================================================
        // Column
        // ==================================================
        // 垂直排列元件
        child: Column(
          // 主軸置中
          mainAxisAlignment: MainAxisAlignment.center,

          // children
          // 放很多元件
          children: [
            // ============================================
            // ValueListenableBuilder<double>
            // ============================================
            // 監聽 ValueNotifier
            //
            // 當 value 改變時
            // Flutter 會重新建立畫面
            // ============================================
            ValueListenableBuilder<double>(
              // 要監聽的資料
              valueListenable: _opacity,

              // builder
              // 資料改變時執行
              builder: (context, opacity, child) {
                // ========================================
                // AnimatedOpacity
                // ========================================
                // Flutter 透明動畫
                //
                // opacity
                // = 透明度
                // ========================================
                return AnimatedOpacity(
                  // 透明度
                  opacity: opacity,

                  // 動畫時間
                  duration: const Duration(seconds: 1),

                  // onEnd
                  // 動畫結束後執行
                  onEnd: () {
                    // 如果透明度是0
                    if (_opacity.value == 0.0) {
                      // 改回 1.0
                      // 重新顯示
                      _opacity.value = 1.0;
                    }
                  },

                  // child
                  // 要顯示的元件
                  child: const Text(
                    // 顯示文字
                    'Flutter動畫',

                    // 文字樣式
                    style: TextStyle(
                      // 字體大小
                      fontSize: 30,
                    ),
                  ),
                );
              },
            ),

            // 間距
            const SizedBox(height: 20),

            // ============================================
            // ElevatedButton
            // ============================================
            // 漂浮按鈕
            // ============================================
            ElevatedButton(
              // 按下按鈕時執行
              onPressed: _changeOpacity,

              // 按鈕樣式
              style: ElevatedButton.styleFrom(
                // 背景顏色
                backgroundColor: Colors.lightBlue,

                // padding
                // 內距
                padding: const EdgeInsets.symmetric(
                  // 上下
                  vertical: 10,

                  // 左右
                  horizontal: 20,
                ),

                // shape
                // 按鈕形狀
                shape: RoundedRectangleBorder(
                  // 圓角
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // child
              // 按鈕內容
              child: const Text(
                // 顯示文字
                '變透明',

                // 文字樣式
                style: TextStyle(
                  // 字體大小
                  fontSize: 18,

                  // 字體顏色
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
