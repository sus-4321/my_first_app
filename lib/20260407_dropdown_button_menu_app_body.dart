import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(heightFactor: 2.0, child: _DropdownWidget());
  }
}

class _DropdownWidget extends StatefulWidget {
  const _DropdownWidget();

  @override
  State<_DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<_DropdownWidget> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: const Text('請選擇', style: TextStyle(fontSize: 22)),

      value: selectedValue,

      items: const <DropdownMenuItem<int>>[
        DropdownMenuItem<int>(
          value: 1,
          child: Text('小英', style: TextStyle(fontSize: 22)),
        ),

        DropdownMenuItem<int>(
          value: 2,
          child: Text('小華', style: TextStyle(fontSize: 22)),
        ),

        DropdownMenuItem<int>(
          value: 3,
          child: Text('小雅', style: TextStyle(fontSize: 22)),
        ),
      ],

      onChanged: (int? value){
        setState(() {
          selectedValue = value;
        });
      }
    );
  }
}
