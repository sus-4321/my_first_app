import 'package:flutter/material.dart';

// 匯入共用資料
import 'package:my_first_app/20260526_order_data.dart';

// 主餐選擇頁
class SelectMainCourse extends StatelessWidget {
  SelectMainCourse({super.key});

  // 主餐資料
  final List<String> _mainCourses = ['牛肉麵', '排骨飯', '魚排飯'];

  // 記錄目前選中的項目
  final ValueNotifier<int?> _selectedItem = ValueNotifier<int?>(
    Data.mainCourseItem,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 攔截返回鍵
      onWillPop: () => _backToHomePage(context),

      child: Scaffold(
        appBar: AppBar(title: const Text('選擇主餐')),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 250,

                margin: const EdgeInsets.symmetric(vertical: 10),

                child: ValueListenableBuilder<int?>(
                  // 監聽目前選項
                  valueListenable: _selectedItem,

                  builder:
                      (BuildContext context, int? selectedItem, Widget? child) {
                        return Column(
                          children: List.generate(_mainCourses.length, (index) {
                            return RadioListTile<int>(
                              // 每個選項值
                              value: index,

                              // 目前選中的值
                              groupValue: selectedItem,

                              // 標題
                              title: Text(
                                _mainCourses[index],
                                style: const TextStyle(fontSize: 20),
                              ),

                              // 點選事件
                              onChanged: (value) {
                                // 更新資料
                                _selectedItem.value = value;
                              },
                            );
                          }),
                        );
                      },
                ),
              ),

              // 確定按鈕
              ElevatedButton(
                // 回首頁
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
  Future<bool> _backToHomePage(BuildContext context) async {
    // 儲存選擇 index
    Data.mainCourseItem = _selectedItem.value;

    // 取得主餐名稱
    final String? mainCourse = Data.mainCourseItem != null
        ? _mainCourses[Data.mainCourseItem!]
        : null;

    // 回上一頁並傳值
    Navigator.pop(context, mainCourse);

    return true;
  }
}
