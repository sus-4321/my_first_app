import 'dart:ffi';

import 'package:flutter/material.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 200.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0),

            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 20.0),
              decoration: const InputDecoration(
                labelText: "請輸入文字",
                labelStyle: TextStyle(fontSize: 20.0),
              ),
            ),
          ),

          ElevatedButton(
            child: const Text("請按"),
            onPressed: () => _showSnackBar(context, _controller.text),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg.isEmpty ? "請輸入文字" : msg,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

}
