import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '對話盒範例',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const List<String> cities = ['倫敦', '東京', '舊金山'];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 顯示結果
  final ValueNotifier<String> _dialogResult = ValueNotifier('');

  // 記錄選到的城市索引
  final ValueNotifier<int?> _selectedCity = ValueNotifier(null);

  @override
  void dispose() {
    _dialogResult.dispose();
    _selectedCity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('對話盒範例')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await _showCityDialog(context);

                if (result != null) {
                  _dialogResult.value = result;
                }
              },
              child: const Text('顯示對話盒', style: TextStyle(fontSize: 20)),
            ),

            const SizedBox(height: 20),

            ValueListenableBuilder<String>(
              valueListenable: _dialogResult,
              builder: _buildDialogResult,
            ),
          ],
        ),
      ),
    );
  }

  // 顯示城市選擇對話盒
  Future<String?> _showCityDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

          content: ValueListenableBuilder<int?>(
            valueListenable: _selectedCity,
            builder: _buildCityOptions,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, '');
              },
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _selectedCity.value == null
                      ? ''
                      : MyHomePage.cities[_selectedCity.value!],
                );
              },
              child: const Text(
                '確定',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  // 建立城市選項
  Widget _buildCityOptions(
    BuildContext context,
    int? selectedItem,
    Widget? child,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(MyHomePage.cities.length, (index) {
        return RadioListTile<int>(
          value: index,
          groupValue: selectedItem,
          title: Text(
            MyHomePage.cities[index],
            style: const TextStyle(fontSize: 20),
          ),
          onChanged: (value) {
            _selectedCity.value = value;
          },
        );
      }),
    );
  }

  // 顯示選擇結果
  Widget _buildDialogResult(
    BuildContext context,
    String result,
    Widget? child,
  ) {
    return Text(
      result.isEmpty ? '尚未選擇城市' : '選擇城市：$result',
      style: const TextStyle(fontSize: 22),
    );
  }
}
