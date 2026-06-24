// ======================================================
// dart:math
// ======================================================
// 匯入 Dart 內建的數學函式庫
// 裡面有：pi、sin、cos、sqrt...等數學功能
//
// 這裡會用到 pi（圓周率）
// 因為旋轉動畫需要角度計算
// ======================================================
import 'dart:math';

// ======================================================
// Flutter Material 元件庫
// ======================================================
// Flutter 最常用的 UI 套件
//
// 裡面有：
// MaterialApp
// Scaffold
// AppBar
// Text
// Center
// Colors
// 等等...
//
// 幾乎 Flutter 基本畫面都會用到
// ======================================================
import 'package:flutter/material.dart';

// ======================================================
// main()
// ======================================================
// Flutter 程式進入點
//
// 所有 Flutter App 都從 main() 開始執行
// ======================================================
void main() {
  // runApp()
  // 啟動 Flutter App
  //
  // const MyApp()
  // 建立 MyApp 元件
  runApp(const MyApp());
}

// ======================================================
// MyApp
// ======================================================
// 整個 App 最外層
//
// extends = 繼承
//
// StatelessWidget
// → 無狀態元件
// → 畫面不會自己變化
//
// 例如：
// 標題
// 固定文字
// 固定畫面
// ======================================================
class MyApp extends StatelessWidget {
  // 建構子 constructor
  //
  // super.key
  // Flutter 用來識別 Widget 的 key
  const MyApp({super.key});

  // ======================================================
  // build()
  // ======================================================
  // build = 建立畫面
  //
  // Flutter 所有畫面幾乎都靠 build()
  // ======================================================
  @override
  Widget build(BuildContext context) {
    // MaterialApp
    // Flutter App 主架構
    return MaterialApp(
      // App 名稱
      title: 'Flutter Animation Demo',

      // 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // App 主題設定
      theme: ThemeData(
        // primarySwatch
        // App 主要顏色
        //
        // Colors.blue
        // 藍色主題
        primarySwatch: Colors.blue,
      ),

      // home
      // App 首頁
      //
      // const MyHomePage()
      // 顯示 MyHomePage 畫面
      home: const MyHomePage(),
    );
  }
}

// ======================================================
// MyHomePage
// ======================================================
// App 首頁畫面
//
// StatelessWidget
// → 畫面本身不會變動
// ======================================================
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold
    // Flutter 頁面骨架
    //
    // 常用：
    // AppBar
    // body
    // drawer
    // bottomNavigationBar
    return Scaffold(
      // ==================================================
      // AppBar
      // ==================================================
      // 上方標題列
      appBar: AppBar(
        // Text()
        // 顯示文字
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
// → 有狀態元件
//
// 可以改變畫面
// 可以做動畫
// 可以更新資料
//
// Flutter 動畫幾乎都用 StatefulWidget
// ======================================================
class AnimationWrapper extends StatefulWidget {
  const AnimationWrapper({super.key});

  // ======================================================
  // createState()
  // ======================================================
  // 建立 State 狀態物件
  //
  // _AnimationWrapperState
  // 真正控制動畫的地方
  // ======================================================
  @override
  State<AnimationWrapper> createState() => _AnimationWrapperState();
}

// ======================================================
// _AnimationWrapperState
// ======================================================
// State = 狀態管理
//
// with
// → 混入功能
//
// SingleTickerProviderStateMixin
// → 提供動畫更新頻率
//
// Ticker
// → 類似動畫時鐘
//
// Flutter 動畫常常需要這個
// ======================================================
class _AnimationWrapperState extends State<AnimationWrapper>
    with SingleTickerProviderStateMixin {
  // ======================================================
  // AnimationController
  // ======================================================
  // 動畫控制器
  //
  // 控制：
  // 播放
  // 停止
  // 倒轉
  // 時間
  //
  // late
  // → 之後才初始化
  //
  // final
  // → 只能指定一次
  // ======================================================
  late final AnimationController _animationController;

  // ======================================================
  // Animation<double>
  // ======================================================
  // double = 小數
  //
  // 這裡儲存旋轉角度
  //
  // 例如：
  // 0
  // 1.5
  // 3.14
  // ======================================================
  late final Animation<double> _rotationAnimation;

  // ======================================================
  // initState()
  // ======================================================
  // 元件建立時執行一次
  //
  // 很適合：
  // 初始化動畫
  // 載入資料
  // 啟動設定
  // ======================================================
  @override
  void initState() {
    // 一定要先呼叫父類別
    super.initState();

    // ====================================================
    // 建立動畫控制器
    // ====================================================
    _animationController = AnimationController(
      // duration
      // 動畫時間
      //
      // 3 秒
      duration: const Duration(seconds: 3),

      // vsync
      // 同步螢幕刷新率
      //
      // this
      // 目前這個 State
      vsync: this,
    );

    // ====================================================
    // CurvedAnimation
    // ====================================================
    // 曲線動畫
    //
    // 可以讓動畫更自然
    // ====================================================
    final curvedAnimation = CurvedAnimation(
      // parent
      // 父動畫控制器
      parent: _animationController,

      // curve
      // 動畫曲線
      //
      // fastOutSlowIn
      // 開始快
      // 中間慢
      // 結尾再順一下
      curve: Curves.fastOutSlowIn,
    );

    // ====================================================
    // Tween<double>
    // ====================================================
    // Tween = 補間動畫
    //
    // begin → 起點
    // end   → 終點
    //
    // 0 ~ 2*pi
    // = 旋轉一整圈
    // ====================================================
    _rotationAnimation =
        Tween<double>(
            // 開始角度
            begin: 0,

            // 結束角度
            //
            // pi = 180度
            // 2*pi = 360度
            end: 2 * pi,
          ).animate(curvedAnimation)
          // ==================================================
          // addStatusListener()
          // ==================================================
          // 監聽動畫狀態
          //
          // 例如：
          // 開始
          // 完成
          // 倒轉完成
          // ==================================================
          ..addStatusListener((status) {
            // 如果動畫播放完成
            if (status == AnimationStatus.completed) {
              // reverse()
              // 倒退播放
              _animationController.reverse();
            }
            // 如果動畫退回起點
            else if (status == AnimationStatus.dismissed) {
              // forward()
              // 往前播放
              _animationController.forward();
            }
          });

    // ====================================================
    // forward()
    // ====================================================
    // 開始播放動畫
    // ====================================================
    _animationController.forward();
  }

  // ======================================================
  // dispose()
  // ======================================================
  // 元件銷毀時執行
  //
  // 要釋放動畫資源
  //
  // 不然可能記憶體浪費
  // ======================================================
  @override
  void dispose() {
    // 釋放動畫控制器
    _animationController.dispose();

    super.dispose();
  }

  // ======================================================
  // build()
  // ======================================================
  // 建立畫面
  // ======================================================
  @override
  Widget build(BuildContext context) {
    // ====================================================
    // AnimatedBuilder
    // ====================================================
    // Flutter 動畫專用 Widget
    //
    // 動畫更新時
    // builder 會一直重新執行
    // ====================================================
    return AnimatedBuilder(
      // animation
      // 要監聽的動畫
      animation: _rotationAnimation,

      // ==================================================
      // builder
      // ==================================================
      // 動畫每更新一次
      // 這裡就重畫一次
      // ==================================================
      builder: (context, child) {
        // Transform.rotate
        // 旋轉 Widget
        return Transform.rotate(
          // angle
          // 旋轉角度
          //
          // value
          // 目前動畫數值
          angle: _rotationAnimation.value,

          // alignment
          // 旋轉中心點
          //
          // center
          // 中央旋轉
          alignment: Alignment.center,

          // child
          // 要旋轉的元件
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
