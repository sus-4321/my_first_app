// ======================================================
// Flutter Material 套件
// ======================================================
// Flutter 最常用 UI 套件
//
// 裡面有：
// MaterialApp
// Scaffold
// Text
// AppBar
// Center
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
// 無狀態元件
//
// 適合：
// 固定畫面
// 不會變動的內容
// ======================================================
class MyApp extends StatelessWidget {
  // 建構子
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
// 首頁畫面
// ======================================================
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
      body: const Center(
        // Center
        // 置中元件
        //
        // child
        // 裡面放子元件
        child: AnimationWrapper(),
      ),
    );
  }
}

// ======================================================
// AnimationWrapper
// ======================================================
// StatefulWidget
// 有狀態元件
//
// 動畫一定幾乎都用 StatefulWidget
// ======================================================
class AnimationWrapper extends StatefulWidget {
  const AnimationWrapper({super.key});

  // ====================================================
  // createState()
  // ====================================================
  // 建立 State 狀態物件
  // ====================================================
  @override
  State<AnimationWrapper> createState() => _AnimationWrapperState();
}

// ======================================================
// _AnimationWrapperState
// ======================================================
// 真正控制動畫的地方
//
// with
// = 混入功能
//
// SingleTickerProviderStateMixin
// = 提供動畫更新頻率
// ======================================================
class _AnimationWrapperState extends State<AnimationWrapper>
    with SingleTickerProviderStateMixin {
  // ====================================================
  // AnimationController
  // ====================================================
  // 動畫控制器
  //
  // 控制：
  // 開始
  // 停止
  // 倒退
  // 動畫時間
  // ====================================================
  late final AnimationController _animationController;

  // ====================================================
  // Animation<double>
  // ====================================================
  // 動畫數值
  //
  // double
  // = 小數
  //
  // scale
  // = 縮放大小
  // ====================================================
  late final Animation<double> _scaleAnimation;

  // ====================================================
  // initState()
  // ====================================================
  // 元件建立時執行一次
  //
  // 適合初始化動畫
  // ====================================================
  @override
  void initState() {
    // 先呼叫父類別
    super.initState();

    // ==================================================
    // AnimationController
    // ==================================================
    // 建立動畫控制器
    _animationController = AnimationController(
      // duration
      // 動畫時間
      //
      // 3 秒
      duration: const Duration(seconds: 3),

      // vsync
      // 同步螢幕更新率
      //
      // this
      // 目前這個 State
      vsync: this,
    );

    // ==================================================
    // CurvedAnimation
    // ==================================================
    // 曲線動畫
    //
    // 讓動畫更自然
    // ==================================================
    final curvedAnimation = CurvedAnimation(
      // 父動畫控制器
      parent: _animationController,

      // 動畫曲線
      //
      // fastOutSlowIn
      // 開始快
      // 中間慢
      // 最後順順停下
      curve: Curves.fastOutSlowIn,
    );

    // ==================================================
    // Tween<double>
    // ==================================================
    // 補間動畫
    //
    // begin = 開始值
    // end   = 結束值
    //
    // 0.5 → 2.5
    //
    // 意思：
    // 從 0.5 倍放大到 2.5 倍
    // ==================================================
    _scaleAnimation =
        Tween<double>(
            // 起始大小
            begin: 0.5,

            // 結束大小
            end: 2.5,
          ).animate(curvedAnimation)
          // ================================================
          // addStatusListener()
          // ================================================
          // 監聽動畫狀態
          //
          // completed
          // = 播放完成
          //
          // dismissed
          // = 回到起點
          // ================================================
          ..addStatusListener((status) {
            // 如果動畫播放完成
            if (status == AnimationStatus.completed) {
              // reverse()
              // 倒退播放
              _animationController.reverse();
            }
            // 如果動畫回到起點
            else if (status == AnimationStatus.dismissed) {
              // forward()
              // 往前播放
              _animationController.forward();
            }
          });

    // ==================================================
    // 開始播放動畫
    // ==================================================
    _animationController.forward();
  }

  // ====================================================
  // dispose()
  // ====================================================
  // 元件銷毀時執行
  //
  // 釋放記憶體
  // ====================================================
  @override
  void dispose() {
    // 釋放動畫控制器
    _animationController.dispose();

    super.dispose();
  }

  // ====================================================
  // build()
  // ====================================================
  // 建立畫面
  // ====================================================
  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder
    // Flutter 動畫專用 Widget
    return AnimatedBuilder(
      // 要監聽的動畫
      animation: _scaleAnimation,

      // ==================================================
      // builder
      // ==================================================
      // 動畫更新時
      // 這裡會一直重新執行
      // ==================================================
      builder: (context, child) {
        // Transform.scale
        // 縮放 Widget
        return Transform.scale(
          // scale
          // 縮放倍率
          //
          // value
          // 目前動畫數值
          scale: _scaleAnimation.value,

          // 縮放中心點
          alignment: Alignment.center,

          // 要縮放的元件
          child: child,
        );
      },

      // ==================================================
      // child
      // ==================================================
      // 真正顯示的內容
      // ==================================================
      child: const Text(
        // 顯示文字
        'Flutter動畫',

        // 文字樣式
        style: TextStyle(
          // 字體大小
          fontSize: 30,

          // 粗體
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
