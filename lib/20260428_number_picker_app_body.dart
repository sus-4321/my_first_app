import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final ValueNotifier<int> _age = ValueNotifier(20);
  final ValueNotifier<String> _text = ValueNotifier('');

 static const int _maxAge = 100;
 static const int _minAge = 0;

 @override
 void dispose(){
  _age.dispose();
  _text.dispose();
  super.dispose();
 }

 @override
 Widget build(BuildContext context){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ValueListenableBuilder<int>(
          valueListenable: _age,
         builder: (context, selectedAge, _){
          return NumberPicker(
            value: selectedAge,
            minValue: _minAge,
            maxValue: _maxAge,
            onChanged: (newValue) => _age.value = newValue,
          );
         }
         ),
         const SizedBox(height: 10),
         ElevatedButton(
          child: const Text('確定'),
          onPressed: (){
            _text.value = '年齡 : ${_age.value}'; 
          },
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<String>(valueListenable: _text,
           builder: (context, text, _){
            return Text(text, style: const TextStyle(fontSize: 20));
           },
           ),
      ],
    ),
  );
 }
}
    