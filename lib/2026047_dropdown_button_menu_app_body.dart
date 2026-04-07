import 'package:flutter/material.dart'; // Flutter 原生 UI 元件庫
import 'package:fluttertoast/fluttertoast.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2.0,
      child: PopupMenuButton<int>(
        color: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        offset: const Offset(100, 30),
        onSelected: (value) => _showSnackBar(context, "你選擇的偶像 $value"),
        onCanceled: () => _showSnackBar(context, "你取消了選擇"),
        itemBuilder: (context) => const [
         PopupMenuItem<int>(
          value: 1,
          child: Text("將太郎", style: TextStyle(fontSize: 20.0),),
         ),
  
        PopupMenuItem<int>(
          value: 2,
          child: Text("成燦", style: TextStyle(fontSize: 20.0),),
         ),

          PopupMenuItem<int>(
            value: 3,
            child: Text("恩奭", style: TextStyle(fontSize: 20.0),),
          ),

          PopupMenuItem<int>(
          value: 2,
          child: Text("元彬", style: TextStyle(fontSize: 20.0),),
         ),

         PopupMenuItem<int>(
          value: 2,
          child: Text("炤熙", style: TextStyle(fontSize: 20.0),),
         ), 

         PopupMenuItem<int>(
          value: 2,
          child: Text("Anton", style: TextStyle(fontSize: 20.0),),
         ),

        ],
      ),
    );
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
}