// ignore_for_file: file_names

import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

@override
Widget build(BuildContext context){
  return MaterialApp(
    title:"We are Riize!!",
    home:const MyHomePage(),
    debugShowCheckedModeBanner: false,
  );
}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('We are Riize!!'),
      ),
      body: const Center(
        child: Text('Welcome to My App'),
      ),
    );
  }
}
