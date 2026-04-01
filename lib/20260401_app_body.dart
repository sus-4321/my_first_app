import 'package:flutter/material.dart'; // Flutter 原生 UI 元件庫
import 'package:fluttertoast/fluttertoast.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: ElevatedButton(
        //
        onPressed: () => showSnackBar(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.indigoAccent,
          elevation: 8.0,
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        ),

        child: const Text(
          "按我會爆破哦",
          style: TextStyle(fontSize: 20.0, color: Colors.purple),
        ),
      ),
    );
  }

  void showToast() {
  Fluttertoast.showToast(
    msg: "WoW,你完蛋了", // 彈出的文字內容
    toastLength: Toast.LENGTH_LONG, // 訊息顯示的時間長度（LONG 約 3.5 秒）
    gravity: ToastGravity.CENTER,    // 訊息彈出的位置（畫面的正中央）
    backgroundColor: Colors.blue,   // Toast 的背景顏色
    textColor: Colors.white,        // Toast 的文字顏色
    fontSize: 20.0,                // 文字大小
  );
}

void showSnackBar(BuildContext context){
  final snackBar = SnackBar(
    content: const Text("開心鈕"),
    duration: const Duration(seconds:3),
    backgroundColor: Colors.greenAccent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    action: SnackBarAction(
      label:"悶氣鈕",
      textColor: Colors.amberAccent,
      onPressed: showToast,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}
