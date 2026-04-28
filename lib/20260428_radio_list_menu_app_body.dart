import 'package:flutter/material.dart';

const List<String> cities = ["台北", "台中", "台南"];

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final ValueNotifier<String> _cityName = ValueNotifier<String>("");
  final ValueNotifier<int> _selectedCity = ValueNotifier<int>(0);

  @override
  void dispose() {
    _cityName.dispose();
    _selectedCity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedCity,
              builder: _radioButtonBuilder,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              child: const Text('確定'),
              onPressed: () {
                _cityName.value = cities[_selectedCity.value];
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ValueListenableBuilder<String>(
              valueListenable: _cityName,
              builder: _cityNameWidgetBuilder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityNameWidgetBuilder(
    BuildContext context,
    String cityName,
    Widget? child,
  ) {
    return Text(cityName, style: const TextStyle(fontSize: 20));
  }

  Widget _radioButtonBuilder(
    BuildContext context,
    int selectedItem,
    Widget? child,    
  ) {
    final List<Widget> radioItems = [];

    for (var i = 0; i < cities.length; i++) {
      radioItems.add(
        RadioListTile<int>(
          value: i,
          groupValue: selectedItem,
          title: Text(cities[i], style: const TextStyle(fontSize: 20)),
          onChanged: (int? value) {
            if (value != null) {
              _selectedCity.value = value;
            }
          },
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: radioItems,
    );
  }
}
