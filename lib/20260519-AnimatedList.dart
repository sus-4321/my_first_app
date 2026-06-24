import 'package:flutter/material.dart';

// 主程式進入點
void main() {
  // runApp
  // = 啟動 Flutter App
  runApp(const MyApp());
}

// MyApp
// = App 最外層元件
class MyApp extends StatelessWidget {
  // 建構式
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp
    // = Flutter App 基本架構
    return MaterialApp(
      // title
      // = App 名稱
      title: 'AnimatedList Demo',

      // debugShowCheckedModeBanner
      // = 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // theme
      // = App 主題設定
      theme: ThemeData(
        // primarySwatch
        // = App 主色
        primarySwatch: Colors.blue,
      ), // ThemeData
      // home
      // = App 首頁
      home: const MyHomePage(),
    ); // MaterialApp
  }
}

// MyHomePage
// = 首頁 StatefulWidget
class MyHomePage extends StatefulWidget {
  // 建構式
  const MyHomePage({super.key});

  @override
  // createState
  // = 建立頁面狀態
  State<MyHomePage> createState() => _MyHomePageState();
}

// _MyHomePageState
// = 首頁狀態管理
class _MyHomePageState extends State<MyHomePage> {
  // _listKey
  // = AnimatedList 控制 Key
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // _items
  // = List 資料
  final List<String> _items = [
    // 第一筆資料
    '1',

    // 第二筆資料
    '2',

    // 第三筆資料
    '3',
  ];

  // _itemLastNum
  // = 最新流水號
  int _itemLastNum = 3;

  // _addItem
  // = 新增資料
  void _addItem() {
    // newItem
    // = 新資料編號
    final newItem = (++_itemLastNum).toString();

    // add
    // = 新增資料到 List
    _items.add(newItem);

    // insertItem
    // = AnimatedList 新增動畫
    _listKey.currentState?.insertItem(
      // 新增位置
      _items.length - 1,

      // duration
      // = 動畫時間
      duration: const Duration(
        // milliseconds
        // = 毫秒
        milliseconds: 300,
      ), // Duration
    );
  }

  // _removeItem
  // = 刪除資料
  void _removeItem(int index) {
    // removedItem
    // = 被刪除資料
    final removedItem = _items[index];

    // removeAt
    // = 刪除指定資料
    _items.removeAt(index);

    // removeItem
    // = AnimatedList 刪除動畫
    _listKey.currentState?.removeItem(
      // 刪除位置
      index,

      // builder
      // = 刪除動畫畫面
      (context, animation) {
        // SizeTransition
        // = 縮放動畫
        return SizeTransition(
          // sizeFactor
          // = 動畫大小變化
          sizeFactor: animation,

          // child
          // = 動畫元件
          child: Card(
            // child
            // = Card 內容
            child: ListTile(
              // title
              // = 主標題
              title: Text(
                // 顯示刪除資料
                removedItem,

                // style
                // = 文字樣式
                style: const TextStyle(
                  // fontSize
                  // = 字體大小
                  fontSize: 20,
                ), // TextStyle
              ), // Text
            ), // ListTile
          ), // Card
        ); // SizeTransition
      },

      // duration
      // = 動畫時間
      duration: const Duration(
        // milliseconds
        // = 毫秒
        milliseconds: 300,
      ), // Duration
    );
  }

  // _buildItem
  // = 建立單一 List 項目
  Widget _buildItem(
    // BuildContext
    // = Flutter 畫面環境
    BuildContext context,

    // index
    // = List 索引值
    int index,

    // animation
    // = AnimatedList 動畫
    Animation<double> animation,
  ) {
    // SizeTransition
    // = 新增動畫效果
    return SizeTransition(
      // sizeFactor
      // = 大小動畫
      sizeFactor: animation,

      // child
      // = 動畫內容
      child: Card(
        // margin
        // = Card 外距
        margin: const EdgeInsets.symmetric(
          // horizontal
          // = 左右距離
          horizontal: 12,

          // vertical
          // = 上下距離
          vertical: 6,
        ), // EdgeInsets.symmetric
        // child
        // = Card 內容
        child: ListTile(
          // title
          // = 主標題
          title: Text(
            // 顯示資料
            _items[index],

            // style
            // = 文字樣式
            style: const TextStyle(
              // fontSize
              // = 字體大小
              fontSize: 20,
            ), // TextStyle
          ), // Text
          // onTap
          // = 點擊新增資料
          onTap: _addItem,

          // onLongPress
          // = 長按刪除資料
          onLongPress: () => _removeItem(index),
        ), // ListTile
      ), // Card
    ); // SizeTransition
  }

  @override
  Widget build(BuildContext context) {
    // appBar
    // = AppBar 元件
    final appBar = AppBar(
      // title
      // = AppBar 標題
      title: const Text(
        // 顯示文字
        'AnimatedList 範例',
      ), // Text
      // centerTitle
      // = 標題置中
      centerTitle: true,
    ); // AppBar

    // animatedList
    // = AnimatedList 元件
    final animatedList = AnimatedList(
      // key
      // = AnimatedList Key
      key: _listKey,

      // initialItemCount
      // = 初始資料數量
      initialItemCount: _items.length,

      // itemBuilder
      // = 建立每筆資料畫面
      itemBuilder: _buildItem,
    ); // AnimatedList

    // Scaffold
    // = App 頁面骨架
    return Scaffold(
      // appBar
      // = 上方工具列
      appBar: appBar,

      // body
      // = 頁面內容
      body: animatedList,
    ); // Scaffold
  }
}
