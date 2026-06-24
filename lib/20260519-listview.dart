import 'package:flutter/material.dart';

// 主程式進入點
void main() {
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
    // = Flutter 的主要 App 架構
    return MaterialApp(
      // debugShowCheckedModeBanner
      // = 移除右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // title
      // = App 名稱
      title: 'ListView 範例',

      // theme
      // = App 主題顏色設定
      theme: ThemeData(
        // primarySwatch
        // = App 主要顏色
        primarySwatch: Colors.blue,
      ),

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
  // _selectedItem
  // = 儲存目前點選的項目文字
  final ValueNotifier<String> _selectedItem = ValueNotifier('');

  // _items
  // = ListView 資料
  final List<Map<String, String>> _items = [
    // 第一筆資料
    {'title': '第四項', 'image': 'assets/images/4.png'},

    // 第二筆資料
    {'title': '第五項', 'image': 'assets/images/5.png'},

    // 第三筆資料
    {'title': '第六項', 'image': 'assets/images/6.png'},
  ];

  @override
  // dispose
  // = 頁面關閉時釋放記憶體
  void dispose() {
    // _selectedItem.dispose
    // = 清除 ValueNotifier
    _selectedItem.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold
    // = App 頁面骨架
    return Scaffold(
      // appBar
      // = 上方工具列
      appBar: AppBar(
        // title
        // = AppBar 標題
        title: const Text('ListView 範例'),
      ),

      // body
      // = 頁面主要內容
      body: Padding(
        // padding
        // = 內距設定
        padding: const EdgeInsets.symmetric(vertical: 10),

        // child
        // = Padding 內的元件
        child: Column(
          // children
          // = Column 裡面的元件
          children: [
            // ValueListenableBuilder
            // = 監聽資料變化自動更新畫面
            ValueListenableBuilder<String>(
              // valueListenable
              // = 要監聽的變數
              valueListenable: _selectedItem,

              // builder
              // = 畫面更新內容
              builder: (context, itemName, child) {
                // Text
                // = 顯示目前點選項目
                return Text(
                  // 顯示文字
                  itemName,

                  // style
                  // = 文字樣式
                  style: const TextStyle(
                    // fontSize
                    // = 文字大小
                    fontSize: 20,
                  ),
                ); // Text
              },
            ), // ValueListenableBuilder
            // Expanded
            // = 讓 ListView 撐滿剩餘空間
            Expanded(
              // child
              // = Expanded 內的元件
              child: ListView.separated(
                // itemCount
                // = ListView 項目數量
                itemCount: _items.length,

                // itemBuilder
                // = 建立每一筆資料畫面
                itemBuilder: (context, index) {
                  // item
                  // = 取得目前資料
                  final item = _items[index];

                  // ListTile
                  // = ListView 單一項目
                  return ListTile(
                    // leading
                    // = 左側元件
                    leading: Padding(
                      // padding
                      // = 內距設定
                      padding: const EdgeInsets.symmetric(
                        // vertical
                        // = 上下距離
                        vertical: 8,

                        // horizontal
                        // = 左右距離
                        horizontal: 5,
                      ), // EdgeInsets.symmetric
                      // child
                      // = Padding 內元件
                      child: CircleAvatar(
                        // backgroundImage
                        // = 圓形圖片
                        backgroundImage: AssetImage(item['image']!),
                      ), // CircleAvatar
                    ), // Padding
                    // title
                    // = 主標題
                    title: Text(
                      // 顯示標題文字
                      item['title']!,

                      // style
                      // = 文字樣式
                      style: const TextStyle(
                        // fontSize
                        // = 字體大小
                        fontSize: 20,
                      ),
                    ), // Text
                    // subtitle
                    // = 副標題
                    subtitle: const Text(
                      // 顯示內容
                      '項目說明',

                      // style
                      // = 文字樣式
                      style: TextStyle(
                        // fontSize
                        // = 字體大小
                        fontSize: 16,
                      ),
                    ), // Text
                    // trailing
                    // = 右側圖示
                    trailing: const Icon(
                      // Icons.keyboard_arrow_right
                      // = 右箭頭圖示
                      Icons.keyboard_arrow_right,
                    ),

                    // onTap
                    // = 點擊事件
                    onTap: () {
                      // 更新點選文字
                      _selectedItem.value = '點選 ${item['title']}';
                    },
                  ); // ListTile
                },

                // separatorBuilder
                // = 每個項目之間的分隔線
                separatorBuilder: (context, index) {
                  // Divider
                  // = 分隔線元件
                  return const Divider();
                },
              ), // ListView.separated
            ), // Expanded
          ],
        ), // Column
      ), // Padding
    ); // Scaffold
  }
}
