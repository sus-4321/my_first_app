import 'package:flutter/material.dart'; // Flutter 原生 UI 元件庫
import 'package:fluttertoast/fluttertoast.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              //
              onPressed: () => _showSnackBar(context, "按了真的會爆哦！"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.indigoAccent,
                elevation: 8.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15.0,
                ),
              ),

              child: const Text(
                "按我會爆炸哦",
                style: TextStyle(fontSize: 20.0, color: Colors.purple),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextButton(
              onPressed: () => _showSnackBar(context, "按我TextButton會爆炸哦"),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 185, 9, 67),
                foregroundColor: const Color.fromARGB(255, 131, 11, 111),
              ),
              child: Text(
                "WoW,太養眼了吧",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 149, 226, 6),
                ),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: OutlinedButton(
              onPressed: () => _showSnackBar(context, "按我OutlinedButton會爆炸哦"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 223, 18, 144),
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              side: const BorderSide(
                color: Colors.deepOrange,
                width: 3.0,
                style: BorderStyle.solid,
              ),
              ),
              child: Text(
                "帥炸了吧",
                style: TextStyle(fontSize: 20.0, color: const Color.fromARGB(255, 187, 4, 44)),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: IconButton(
              onPressed: () => _showSnackBar(context, "按我IconButton會爆炸哦"),
              icon: const Icon(Icons.warning_amber_outlined),
              color: Colors.redAccent,
              iconSize: 40.0,
              tooltip: "危險按鈕",
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: FloatingActionButton(
              onPressed: () => _showSnackBar(context, "按我FloatingActionButton會爆炸哦"),
              shape: const CircleBorder(),
              elevation: 5.0,
              child: const Icon(Icons.warning_amber_outlined),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton.icon(
              onPressed: () => _showSnackBar(context, "按我FloatingActionButton會爆炸哦"),
              icon: const Icon(Icons.warning_amber_outlined),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.indigoAccent,
                elevation: 8.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15.0,
                ),
              ),
              label: const Text("浮動按鈕",
              style: TextStyle(fontSize: 20.0, color: Colors.purpleAccent),),
            ),
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
