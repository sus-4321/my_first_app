import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  static const _male = '男';
  static const _female = '女';

  final ValueNotifier<int> _selectedGender = ValueNotifier(0);
  final ValueNotifier<int> _age = ValueNotifier(20);
  final ValueNotifier<String> _text = ValueNotifier('');

 static const int _maxAge = 100;
 static const int _minAge = 0;

 @override
 void dispose(){
  _selectedGender.dispose();
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
        const Text('性別:', style: TextStyle(fontSize: 20)),

        ValueListenableBuilder<int>(
          valueListenable: _selectedGender,
         builder: _radioButtonBuilder,
         ),
          
         const SizedBox(height: 10),

         const Text('年齡:', style: TextStyle(fontSize: 20)),

         ValueListenableBuilder<int>(
           valueListenable: _age,
           builder: _agePickerBuilder,
         ),
          const SizedBox(height: 10),
          
         ElevatedButton(
          child: const Text('確定'),
          onPressed: _showSuggestion),
          
          const SizedBox(height: 10),
          ValueListenableBuilder<String>(
            valueListenable: _text,
           builder: _textWidgetBuilder,
           ),                    
      ],
    ),
  );
 }

 Widget _radioButtonBuilder(
  BuildContext context,
  int selectedItem,
  Widget? child,
  ){
    const genders = [_male, _female];

    return Column(
      children: List.generate(genders.length, (i) {
        return Center(
          child: SizedBox(
          width: 200,
          child: RadioListTile<int>(
            value: i,
            groupValue: selectedItem,
            title: Text(genders[i], style: const TextStyle(fontSize: 20)),
            onChanged: (int? value){
              if (value != null){
                _selectedGender.value = value;
              }
            },
            ),
          ),
        );      
   } ),
    );
  }

Widget _agePickerBuilder(
  BuildContext context,
  int selectedAge,
  Widget? child,
){
  return NumberPicker(
    value: selectedAge,
    minValue: _minAge,
    maxValue: _maxAge,
    onChanged: (newValue) => _age.value = newValue,
  );
}
Widget _textWidgetBuilder(BuildContext context, String text, Widget? child){
  return Text(text, style: const TextStyle(fontSize: 20));
}
void _showSuggestion(){
  final gender = _selectedGender.value == 0 ? _male : _female;

  if (gender == _male){
    if (_age.value <=26) {
      _text.value = '不急';
    }
    else if (_age.value <= 30){
      _text.value = '可以考慮了';
    }
    else {
      _text.value = '建議盡快結婚';
    }
  }
  else {
    if (_age.value <= 24) {
      _text.value = '不急';
    }
    else if (_age.value <= 28){
      _text.value = '可以考慮了';
    }
    else {
      _text.value = '建議盡快結婚';
    }
  }
  }
}