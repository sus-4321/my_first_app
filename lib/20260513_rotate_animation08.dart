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
// Icon
// Button
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
      title: 'Animated CrossFade Demo',

      // 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // 主題設定
      theme: ThemeData(
        // App 主顏色
        primarySwatch: Colors.orange,
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
  // ValueNotifier<bool>
  // ====================================================
  // ValueNotifier
  // = 資料變化通知器
  //
  // <bool>
  // = true / false
  //
  // _showText
  // = 是否顯示文字
  // ====================================================
  final ValueNotifier<bool> _showText = ValueNotifier(true);

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
    _showText.dispose();

    super.dispose();
  }

  // ====================================================
  // _toggleView()
  // ====================================================
  // 切換畫面
  // ====================================================
  void _toggleView() {
    // !
    // = 反轉
    //
    // true → false
    // false → true
    _showText.value = !_showText.value;
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
        backgroundColor: Colors.lime,
        title: const Text('Emotional Pop'),
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
            // ValueListenableBuilder<bool>
            // ============================================
            // 監聽 ValueNotifier
            //
            // 當 value 改變時
            // Flutter 會重新建立畫面
            // ============================================
            ValueListenableBuilder<bool>(
              // 要監聽的資料
              valueListenable: _showText,

              // builder
              // 資料改變時執行
              builder: (context, showText, child) {
                // ========================================
                // AnimatedCrossFade
                // ========================================
                // Flutter 交叉淡入淡出動畫
                //
                // 可以切換兩個 Widget
                // ========================================
                return AnimatedCrossFade(
                  // 動畫時間
                  duration: const Duration(seconds: 1),

                  // crossFadeState
                  // 目前顯示哪個 Widget
                  crossFadeState: showText
                      // 顯示第一個
                      ? CrossFadeState.showFirst
                      // 顯示第二個
                      : CrossFadeState.showSecond,

                  // ======================================
                  // firstChild
                  // ======================================
                  // 第一個畫面
                  firstChild: Container(
                    // 寬度
                    width: 300,

                    // 高度
                    height: 120,

                    // 內容置中
                    alignment: Alignment.center,

                    // child
                    // 裡面顯示內容
                    child: const Text(
                      // 顯示文字
                      'RIIZE라이즈',

                      // 文字樣式
                      style: TextStyle(
                        // 字體大小
                        fontSize: 40,

                        // 粗體
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // ======================================
                  // secondChild
                  // ======================================
                  // 第二個畫面
                  secondChild: SizedBox(
                    // 寬度
                    width: 300,

                    // 高度
                    height: 120,

                    // Icon
                    child: const Icon(
                      // 表情 Icon
                      Icons.interpreter_mode,

                      // Icon 大小
                      size: 100,

                      // Icon 顏色
                      color: Color.fromARGB(255, 216, 12, 223),
                    ),
                  ),
                );
              },
            ),

            // 間距
            const SizedBox(height: 30),

            // ============================================
            // ElevatedButton
            // ============================================
            // 漂浮按鈕
            // ============================================
            ElevatedButton(
              // 按下按鈕時執行
              onPressed: _toggleView,

              // 按鈕樣式
              style: ElevatedButton.styleFrom(
                // 背景顏色
                backgroundColor: const Color.fromARGB(255, 201, 112, 10),

                // padding
                // 內距
                padding: const EdgeInsets.symmetric(
                  // 上下
                  vertical: 12,

                  // 左右
                  horizontal: 30,
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
                '加入',

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
