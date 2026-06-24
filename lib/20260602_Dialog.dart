import 'package:flutter/material.dart';

// 應用程式的進入點（所有 Dart 程式都從 main 開始執行）
void main() {
  runApp(const MyApp()); // 啟動並運行 MyApp 這個元件
}

// MyApp 是整個應用程式的根源（Root），這裡使用無狀態元件（StatelessWidget）
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 建構子，super.key 用於 Flutter 內部優化

  @override
  Widget build(BuildContext context) {
    // MaterialApp 是 Flutter 開發 Android/iOS 等應用程式的基礎外殼
    return MaterialApp(
      title: '對話盒範例',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 設定佈景主題的主要顏色為藍色
      ),
      home: const MyHomePage(), // 設定首頁為 MyHomePage 元件
    );
  }
}

// MyHomePage 是首頁，因為畫面需要跟使用者互動並改變狀態，所以使用有狀態元件（StatefulWidget）
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // 建立與其關聯的 State 類別
}

// 這裡負責處理 MyHomePage 的畫面與狀態變更
class _MyHomePageState extends State<MyHomePage> {
  // 1. 定義靜態常數列表，存放供選擇的城市名稱
  static const List<String> _cities = ['倫敦', '東京', '舊金山'];

  // 2. 建立 ValueNotifier（數值通知器），用來監聽與通知畫面的更新
  // _dialogResult 用來記錄並通知「最後畫面上要顯示的城市名稱結果」
  final ValueNotifier<String> _dialogResult = ValueNotifier<String>('');

  // _selectedCity 用來記錄「對話盒中目前點選了第幾個城市（索引值）」，int? 代表可以是 null（尚未選擇）
  final ValueNotifier<int?> _selectedCity = ValueNotifier<int?>(null);

  @override
  void dispose() {
    // 當這個畫面被銷毀時，必須釋放 ValueNotifier 以免記憶體洩漏（Memory Leak）
    _dialogResult.dispose();
    _selectedCity.dispose();
    super.dispose();
  }

  // 異步（async）方法：用來打開對話盒並等待使用者的操作結果
  Future<void> _openDialog() async {
    // await 會卡在這裡，直到對話盒關閉（回傳結果）
    final result = await _showCityDialog();

    // 如果使用者有點擊確定（回傳結果不是 null），就更新主畫面的數值
    if (result != null) {
      _dialogResult.value = result; // 只要修改 .value，有監聽這個變數的畫面就會自動刷新
    }
  }

  // 顯示對話盒的方法，會回傳一個 Future<String?>（可能是選中的城市字串，或取消時為空）
  Future<String?> _showCityDialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // 強制限制：點擊對話盒外部空白處「不會」關閉對話盒
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('請選擇城市'),
          // content 是對話盒的內容物
          content: ValueListenableBuilder<int?>(
            valueListenable: _selectedCity, // 監聽對話盒中「被選中的城市索引」
            builder: _cityOptionsBuilder, // 使用下方自訂的方法來建立單選清單畫面
          ),
          actions: [
            // 取消按鈕
            TextButton(
              onPressed: () {
                // 關閉對話盒，並回傳空字串 ''
                Navigator.pop(dialogContext, '');
              },
              child: const Text('取消'),
            ),
            // 確定按鈕
            ElevatedButton(
              onPressed: () {
                // 點擊確定時關閉對話盒，並判斷是否有選取城市
                Navigator.pop(
                  dialogContext,
                  _selectedCity.value == null
                      ? '' // 如果沒選，回傳空字串
                      : _cities[_selectedCity
                            .value!], // 有選，就回傳對應的城市名稱（! 代表強製轉為非空值）
                );
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  // 建立對話盒內部「城市單選清單」的產生器
  Widget _cityOptionsBuilder(
    BuildContext context,
    int? selectedItem,
    Widget? child,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 讓 Column 的高度剛好包住內容物就好，不要撐滿整個螢幕
      children: List.generate(_cities.length, (index) {
        // 根據城市的數量，循環產生 RadioListTile（帶有文字的單選鈕元件）
        return RadioListTile<int>(
          value: index, // 這個單選鈕代表的數值（0, 1, 2）
          groupValue: selectedItem, // 目前被選中的數值
          title: Text(_cities[index]), // 顯示城市名稱
          onChanged: (value) {
            // 當使用者點擊這個選項時，更新 _selectedCity 的值
            // 這會觸發 ValueListenableBuilder 重新渲染，畫面的單選圈圈就會換位置
            _selectedCity.value = value;
          },
        );
      }),
    );
  }

  // 建立主畫面中「顯示結果文字」的產生器
  Widget _dialogResultBuilder(
    BuildContext context,
    String result,
    Widget? child,
  ) {
    // 收到新的字串時，更新並回傳一個大字體（size: 20）的文字元件
    return Text(result, style: const TextStyle(fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    // 定義頂部導覽列
    final appBar = AppBar(title: const Text('對話盒範例'));

    // 定義主畫面的「顯示對話盒」按鈕
    final showDialogButton = ElevatedButton(
      onPressed: _openDialog, // 點擊時執行上面寫好的 _openDialog 方法
      child: const Text('顯示對話盒', style: TextStyle(fontSize: 20)),
    );

    // 定義畫面的主體（Body）
    final body = Center(
      child: Column(
        children: [
          // 第一個區塊：放按鈕，上下給 10 的外邊距（margin）
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: showDialogButton,
          ),
          // 第二個區塊：放選取結果的文字
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ValueListenableBuilder<String>(
              valueListenable: _dialogResult, // 監聽最終的城市結果
              builder: _dialogResultBuilder, // 結果改變時，呼叫上面定義的 Builder 來刷文字
            ),
          ),
        ],
      ),
    );

    // Scaffold 是頁面結構的骨架，把寫好的 appBar 和 body 放進來組裝
    return Scaffold(appBar: appBar, body: body);
  }
}
