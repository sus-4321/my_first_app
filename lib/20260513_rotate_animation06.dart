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
// Icon
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
  // ValueNotifier<Alignment>
  // ====================================================
  // ValueNotifier
  // = 資料變化通知器
  //
  // 當 value 改變時
  // Flutter 會自動更新畫面
  //
  // Alignment
  // = 對齊位置
  // ====================================================
  final ValueNotifier<Alignment> _alignment = ValueNotifier(
    // 初始位置
    //
    // bottomCenter
    // = 底部中央
    Alignment.bottomCenter,
  );

  // ====================================================
  // dispose()
  // ====================================================
  // 元件銷毀時執行
  //
  // 釋放記憶體
  // ====================================================
  @override
  void dispose() {
    // dispose()
    // 釋放 ValueNotifier
    _alignment.dispose();

    super.dispose();
  }

  // ====================================================
  // _startAnimation()
  // ====================================================
  // 開始動畫
  // ====================================================
  void _startAnimation() {
    // _alignment.value
    // 修改對齊位置
    //
    // topCenter
    // = 上方中央
    _alignment.value = Alignment.topCenter;
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
        // SizedBox
        // ==================================================
        // 固定大小容器
        child: SizedBox(
          // 高度
          height: 500,

          // ==================================================
          // Column
          // ==================================================
          // 垂直排列元件
          child: Column(
            // mainAxisAlignment
            // 主軸對齊
            //
            // end
            // = 靠下
            mainAxisAlignment: MainAxisAlignment.end,

            // children
            // 裡面可以放很多元件
            children: [
              // ============================================
              // Expanded
              // ============================================
              // 自動撐滿剩餘空間
              Expanded(
                child: ValueListenableBuilder<Alignment>(
                  // ==================================================
                  // valueListenable
                  // ==================================================
                  // 要監聽的 ValueNotifier
                  valueListenable: _alignment,

                  // ==================================================
                  // builder
                  // ==================================================
                  // 當 value 改變時
                  // 這裡會重新執行
                  builder: (context, alignment, child) {
                    // ================================================
                    // AnimatedContainer
                    // ================================================
                    // Flutter 動畫容器
                    //
                    // 當屬性改變時
                    // 會自動產生動畫
                    // ================================================
                    return AnimatedContainer(
                      // 動畫時間
                      duration: const Duration(seconds: 3),

                      // 動畫曲線
                      curve: Curves.fastOutSlowIn,

                      // alignment
                      // = 對齊位置
                      alignment: alignment,

                      // onEnd
                      // = 動畫結束後執行
                      onEnd: () {
                        // 回到底部中央
                        _alignment.value = Alignment.bottomCenter;
                      },

                      // child
                      // 要顯示的元件
                      child: child,
                    );
                  },

                  // ==================================================
                  // child
                  // ==================================================
                  // 飛機 Icon
                  child: const Icon(
                    // 飛機圖示
                    Icons.airplanemode_active,

                    // Icon 顏色
                    color: Colors.lightBlue,

                    // Icon 大小
                    size: 50,
                  ),
                ),
              ),

              // ==================================================
              // Container
              // ==================================================
              // 容器元件
              Container(
                // margin
                // 外距
                margin: const EdgeInsets.symmetric(vertical: 20),

                // ================================================
                // ElevatedButton.icon
                // ================================================
                // 有 Icon 的按鈕
                child: ElevatedButton.icon(
                  // 按下按鈕時
                  onPressed: _startAnimation,

                  // icon
                  // 按鈕左邊圖示
                  icon: const Padding(
                    // padding
                    // 內距
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),

                    // Icon
                    child: Icon(
                      // 飛機圖示
                      Icons.airplanemode_active,

                      // Icon 顏色
                      color: Colors.white,
                    ),
                  ),

                  // label
                  // 按鈕文字
                  label: const Padding(
                    padding: EdgeInsets.only(top: 10, right: 20, bottom: 10),

                    child: Text(
                      // 顯示文字
                      '起飛',

                      // 文字樣式
                      style: TextStyle(
                        // 字體大小
                        fontSize: 18,

                        // 字體顏色
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // style
                  // 按鈕樣式
                  style: ElevatedButton.styleFrom(
                    // 背景顏色
                    backgroundColor: Colors.lightBlue,

                    // shape
                    // 按鈕形狀
                    shape: RoundedRectangleBorder(
                      // borderRadius
                      // 圓角
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
