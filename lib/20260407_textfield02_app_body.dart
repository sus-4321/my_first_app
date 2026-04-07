import 'dart:ffi';

import 'package:flutter/material.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final TextEditingController _namecontroller = TextEditingController();

  String _inputName = "";

  @override
  void dispose() {
    _namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0),

            child: TextField(
              controller: _namecontroller,
              style: const TextStyle(fontSize: 20.0),
              decoration: const InputDecoration(
                labelText: "請輸入名字",
                labelStyle: TextStyle(fontSize: 20.0),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              child: const Text("送出"),
              onPressed: (){
                setState(() {
                  _inputName = _namecontroller.text;
                });
              },
            ),
          ),

          Text(_inputName, style: const TextStyle(fontSize: 20.0)),
        ],
      ),
    );
  }
}

