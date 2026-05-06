// ignore: file_names
import 'package:flutter/material.dart'; 
import 'package:photo_view/photo_view.dart';
// Flutter 原生 UI 元件庫
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Browse Images",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage()
      );
  } 
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<int> _imageIndex = ValueNotifier(0);


static const _images = <String>[
  'assets/images/1.png',
  'assets/images/2.png',
  'assets/images/3.png',
];

@override
void dispose(){
  _imageIndex.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(title: const Text('Browse Image'),
    centerTitle: true),
    body: Stack(
      children: [
        Positioned.fill(
          child: ValueListenableBuilder<int>(
            valueListenable: _imageIndex,
            builder: _imageBuilder,
          ),
        ),
        Positioned(bottom: 20, left: 0, right: 0, child: _buildControls()),
      ],
    ),
  );
}
 Widget _imageBuilder(BuildContext context, int index, Widget? child){
  return PhotoView(
    imageProvider: AssetImage(_images[index]),
    minScale: PhotoViewComputedScale.contained ,
    maxScale: PhotoViewComputedScale.covered * 2,
    enableRotation: true,
    backgroundDecoration: const BoxDecoration(color: Colors.indigo),
  );
 }
Widget _buildControls() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _controlButton(icon: Icons.arrow_back_ios, onTap: _previousImage),
      const SizedBox(width: 20),
      ValueListenableBuilder<int>(
        valueListenable: _imageIndex,
        builder: (context, index, _) {
          return Text(
            '${index + 1} / ${_images.length}',
            style: const TextStyle(fontSize: 16, color: Colors.limeAccent),
          );
        },
      ),
      const SizedBox(width: 20),
      _controlButton(icon: Icons.arrow_forward_ios, onTap: _nextImage)
    ],
  );
}
Widget _controlButton({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.cyanAccent),
    ),
  );
}
void _previousImage(){
  _imageIndex.value =
  (_imageIndex.value - 1 + _images.length) %
_images.length;
}
void _nextImage(){
  _imageIndex.value = (_imageIndex.value + 1) % _images.length;
}
}
