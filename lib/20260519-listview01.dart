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
      // debugShowCheckedModeBanner
      // = 關閉右上角 DEBUG 標籤
      debugShowCheckedModeBanner: false,

      // title
      // = App 名稱
      title: 'ListView Demo',

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
  // _listItems
  // = ListView 資料
  final ValueNotifier<List<String>> _listItems = ValueNotifier<List<String>>([
    // 第一筆資料
    '1',

    // 第二筆資料
    '2',

    // 第三筆資料
    '3',
  ]); // ValueNotifier

  @override
  // dispose
  // = 關閉頁面時釋放記憶體
  void dispose() {
    // _listItems.dispose
    // = 清除 ValueNotifier
    _listItems.dispose();

    super.dispose();
  }

  // _addItem
  // = 新增 List 資料
  void _addItem() {
    // newList
    // = 複製目前 List
    final newList = List<String>.from(_listItems.value)
      // add
      // = 新增資料
      ..add((_listItems.value.length + 1).toString());

    // 更新 List 資料
    _listItems.value = newList;
  }

  // _removeItem
  // = 刪除指定資料
  void _removeItem(int index) {
    // newList
    // = 複製目前 List
    final newList = List<String>.from(_listItems.value);

    // removeAt
    // = 刪除指定位置資料
    newList.removeAt(index);

    // 更新 List 資料
    _listItems.value = newList;
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
        title: const Text('ListView範例'), // Text
      ), // AppBar
      // body
      // = 頁面內容
      body: ValueListenableBuilder<List<String>>(
        // valueListenable
        // = 監聽 List 資料變化
        valueListenable: _listItems,

        // builder
        // = 畫面更新內容
        builder: (context, listItems, child) {
          // ListView.separated
          // = 可加入分隔線的 ListView
          return ListView.separated(
            // itemCount
            // = List 資料數量
            itemCount: listItems.length,

            // itemBuilder
            // = 建立每一筆資料畫面
            itemBuilder: (context, index) {
              // ListTile
              // = List 單一項目
              return ListTile(
                // leading
                // = 左側圖示
                leading: const Icon(
                  // Icons.list
                  // = List 圖示
                  Icons.list,
                ), // Icon
                // title
                // = 主標題
                title: Text(
                  // 顯示資料
                  listItems[index],

                  // style
                  // = 文字樣式
                  style: const TextStyle(
                    // fontSize
                    // = 文字大小
                    fontSize: 20,
                  ), // TextStyle
                ), // Text
                // subtitle
                // = 副標題
                subtitle: const Text(
                  // 顯示文字
                  '點擊新增 / 長按刪除',
                ), // Text
                // trailing
                // = 右側圖示
                trailing: const Icon(
                  // Icons.arrow_forward_ios
                  // = 右箭頭圖示
                  Icons.arrow_forward_ios,
                ), // Icon
                // onTap
                // = 點擊事件
                onTap: _addItem,

                // onLongPress
                // = 長按事件
                onLongPress: () => _removeItem(index),
              ); // ListTile
            },

            // separatorBuilder
            // = 每筆資料間的分隔線
            separatorBuilder: (context, index) {
              // Divider
              // = 分隔線元件
              return const Divider(
                // height
                // = 分隔線高度
                height: 1,
              ); // Divider
            },
          ); // ListView.separated
        },
      ), // ValueListenableBuilder
    ); // Scaffold
  }
}
