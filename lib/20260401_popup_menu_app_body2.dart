import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  // 建立一個變數來儲存目前點選的成員照片 URL
  String? _selectedImage;

  // 成員資料對照表 (這裡可以用你實際的圖片路徑或網址)
  final Map<int, String> _memberImages = {
    1: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNjQ4MTZjMjFiMDAwN2M0YzQ0MQ==",
    2: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNjZlMjZiOWFlMDAwOGQxY2UzYw==",
    3: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNjdmMjZiOWFlMDAwOGQxZDA4ZA==",
    4: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNjk1MjZiOWFlMDAwOGQxZDJiMA==",
    5: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNmFjMTZjMjFiMDAwN2M0Yzc0OA==",
    6: "https://imgproxy.poponote.app/1/auto/1000/0/sm/0/aHR0cHM6Ly9hc3NldHMucG9wb25vdGUuYXBwL25vdGUvNjYzMGFhMWUxNmMyMWIwMDA3YzI4MTc3L21lZGlhLzY2MzBjNmM2MjZiOWFlMDAwOGQxZDQ0Ng==",
  };

  @override
  Widget build(BuildContext context) {
    return Column( // 改用 Column 才能同時放選單和照片
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- 這裡顯示選中的照片 ---
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: _selectedImage == null
              ? const Center(child: Text("請選擇成員"))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    // 這裡加個錯誤處理，避免圖片載入失敗時噴錯
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                  ),
                ),
        ),

        const SizedBox(height: 30),

        // --- 原有的 PopupMenuButton ---
        PopupMenuButton<int>(
          child: const ElevatedButton(
            onPressed: null, // 設為 null 因為 PopupMenuButton 本身就有點擊效果
            child: Text("選擇 RIIZE 成員"),
          ),
          onSelected: (value) {
            setState(() {
              // 更新照片路徑
              _selectedImage = _memberImages[value];
            });
            _showSnackBar(context, "你選擇了 $value");
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 1, child: Text("將太郎")),
            PopupMenuItem(value: 2, child: Text("恩奭")),
            PopupMenuItem(value: 3, child: Text("成燦")),
            PopupMenuItem(value: 4, child: Text("元彬")),
            PopupMenuItem(value: 5, child: Text("炤熙")),
            PopupMenuItem(value: 6, child: Text("Anton")),
          ],
        ),
      ],
    );
  }

  // ... 這裡保留你的 _showToast 和 _showSnackBar 函式 ...
}

  void _showToast() {
    Fluttertoast.showToast(
      msg: "WoW,你完蛋了", // 彈出的文字內容
      toastLength: Toast.LENGTH_LONG, // 訊息顯示的時間長度（LONG 約 3.5 秒）
      gravity: ToastGravity.CENTER, // 訊息彈出的位置（畫面的正中央）
      backgroundColor: Colors.blue, // Toast 的背景顏色
      textColor: Colors.white, // Toast 的文字顏色
      fontSize: 20.0, // 文字大小
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      action: SnackBarAction(
        label: "悶氣鈕",
        textColor: Colors.amberAccent,
        onPressed: _showToast,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
