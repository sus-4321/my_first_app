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
// Container
// Colors
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
// 因為畫面會改變
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
  // _barHeight
  // = 長條高度
  // ====================================================
  final ValueNotifier<double> _barHeight = ValueNotifier(100);

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
    _barHeight.dispose();

    super.dispose();
  }

  // ====================================================
  // _changeBarHeight()
  // ====================================================
  // 改變長條高度
  // ====================================================
  void _changeBarHeight() {
    // 三元運算子
    //
    // 格式：
    // 條件 ? true : false
    //
    // 如果目前高度是100
    // 就改成400
    //
    // 否則改回100
    _barHeight.value = _barHeight.value == 100 ? 400 : 100;
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
        // SizedBox
        // 固定大小容器
        child: SizedBox(
          // 高度
          height: 500,

          // ==================================================
          // Column
          // ==================================================
          // 垂直排列元件
          child: Column(
            // 主軸對齊
            //
            // end
            // = 靠下方
            mainAxisAlignment: MainAxisAlignment.end,

            // children
            // 放很多元件
            children: [
              // ============================================
              // ValueListenableBuilder<double>
              // ============================================
              // 監聽 ValueNotifier
              //
              // 當 value 改變時
              // 會重新建立畫面
              // ============================================
              ValueListenableBuilder<double>(
                // 要監聽的資料
                valueListenable: _barHeight,

                // builder
                // 當 value 改變時執行
                builder: _animatedContainerBuilder,
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
                onPressed: _changeBarHeight,

                // 按鈕樣式
                style: ElevatedButton.styleFrom(
                  // 背景顏色
                  backgroundColor: Colors.lightBlue,

                  // padding
                  // 內距
                  padding: const EdgeInsets.symmetric(
                    // 上下內距
                    vertical: 10,

                    // 左右內距
                    horizontal: 20,
                  ),

                  // shape
                  // 按鈕形狀
                  shape: RoundedRectangleBorder(
                    // borderRadius
                    // 圓角
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                // child
                // 按鈕內容
                child: const Text(
                  // 顯示文字
                  '改變高度',

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
      ),
    );
  }

  // ====================================================
  // _animatedContainerBuilder()
  // ====================================================
  // AnimatedContainer 建立器
  //
  // Widget
  // = Flutter 畫面元件
  // ====================================================
  Widget _animatedContainerBuilder(
    // BuildContext
    // Flutter 畫面環境資訊
    BuildContext context,

    // barHeight
    // 長條高度
    double barHeight,

    // child
    // 子元件
    Widget? child,
  ) {
    // ==================================================
    // AnimatedContainer
    // ==================================================
    // Flutter 動畫容器
    //
    // 當屬性改變時
    // Flutter 會自動產生動畫
    // ==================================================
    return AnimatedContainer(
      // 寬度
      width: 60,

      // 高度
      height: barHeight,

      // 動畫時間
      duration: const Duration(seconds: 1),

      // 動畫曲線
      curve: Curves.easeInOut,

      // 顏色
      color: Colors.orangeAccent,
    );
  }
}
