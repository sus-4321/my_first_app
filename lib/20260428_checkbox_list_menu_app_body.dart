import 'package:flutter/material.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  static const _hobbies = <String>[
    '游泳', '跑步', '健身', '看電影', '聽音樂', '打電動',
    '美食', '跳舞', '唱歌', '旅遊', '寫作', '繪畫',
  ];

  final ValueNotifier<List<bool>> _hobbiesSelected = ValueNotifier(
    List<bool>.generate(_hobbies.length, (_) => false),
  );

  final ValueNotifier<String> _text = ValueNotifier('');

  @override
  void dispose() {
    _hobbiesSelected.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView( // 修正點：v 改為大寫 V
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: ValueListenableBuilder<List<bool>>(
                valueListenable: _hobbiesSelected,
                builder: _hobbySelectionBuilder,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('確定'),
              onPressed: _showHobbies,
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<String>(
              valueListenable: _text,
              builder: _textWidgetBuilder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _hobbySelectionBuilder(
    BuildContext context,
    List<bool> selectedList, // 修正點：改名避免與外部變數衝突
    Widget? child,
  ) {
    return Column(
      children: List.generate(_hobbies.length, (i) { // 修正點：逗號改為點號 .length
        return Center(
          child: SizedBox(
            width: 250,
            child: CheckboxListTile(
              title: Text(_hobbies[i], style: const TextStyle(fontSize: 20)),
              value: selectedList[i],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  final newList = List<bool>.from(selectedList);
                  newList[i] = newValue;
                  _hobbiesSelected.value = newList;
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _textWidgetBuilder(BuildContext context, String text, Widget? child) {
    return Text(text, style: const TextStyle(fontSize: 20));
  }

  void _showHobbies() {
    final selected = <String>[];
    for (int i = 0; i < _hobbies.length; i++) {
      if (_hobbiesSelected.value[i]) {
        selected.add(_hobbies[i]);
      }
    }
    _text.value = selected.join('  ');
  }
}