import 'package:flutter/material.dart';


void main() {
  var appTitle = Text("Hello Flutter!!");

  var hiFlutter = Text("Hello World!!", style: TextStyle(fontSize:30));

  var appBar = AppBar(title: appTitle);

  var appBody =Center(child: hiFlutter);

  var app = MaterialApp(
    home: Scaffold(
      appBar: appBar, 
      body: appBody,  
    ),
  );

  runApp(app); 
}

