import 'package:flutter/material.dart';

// 匯入共用資料
import 'package:my_first_app/20260526_order_data.dart';

// 飲料頁
class SelectDrink extends StatelessWidget {
  SelectDrink({super.key});

  // 飲料資料
  final List<String> _drinkList = ['紅茶', '泡沫綠茶'];

  // 記錄目前選擇項目
  final ValueNotifier<int?> _selectedItem = ValueNotifier<int?>(Data.drinkItem);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 攔截返回鍵
      onWillPop: () async {
        _backToHomePage(context);

        return false;
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('選擇飲料')),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(
                width: 250,

                child: ValueListenableBuilder<int?>(
                  valueListenable: _selectedItem,

                  builder:
                      (BuildContext context, int? selectedItem, Widget? child) {
                        return Column(
                          children: List.generate(_drinkList.length, (index) {
                            return RadioListTile<int>(
                              // 每個選項值
                              value: index,

                              // 目前選中的值
                              groupValue: selectedItem,

                              // 文字
                              title: Text(
                                _drinkList[index],
                                style: const TextStyle(fontSize: 20),
                              ),

                              // 點選事件
                              onChanged: (value) {
                                // 更新選項
                                _selectedItem.value = value;
                              },
                            );
                          }),
                        );
                      },
                ),
              ),

              // 間距
              const SizedBox(height: 20),

              // 確定按鈕
              ElevatedButton(
                // 返回首頁
                onPressed: () => _backToHomePage(context),

                child: const Text('確定'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 回首頁
  void _backToHomePage(BuildContext context) {
    // 儲存選擇 index
    Data.drinkItem = _selectedItem.value;

    // 取得飲料名稱
    final String? drink = Data.drinkItem != null
        ? _drinkList[Data.drinkItem!]
        : null;

    // 回上一頁並傳值
    Navigator.pop(context, drink);
  }
}
