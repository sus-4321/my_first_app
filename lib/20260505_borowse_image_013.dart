// ignore: file_names
import 'package:flutter/material.dart'; 
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// import 'package:flutter/foundation.dart';
// Flutter 原生 UI 元件庫
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // 目前圖片 index
  final ValueNotifier<int> _imageIndex = ValueNotifier(0);

  // 圖片清單
  static const List<String> _images = [
    'assets/images/anton10.jpg',
    'assets/images/anton11.jpg',
    'assets/images/anton12.jpg',
    'assets/images/anton13.jpg',
    'assets/images/anton14.jpg',
    'assets/images/anton15.jpg',
    'assets/images/anton16.jpg',
    'assets/images/anton17.jpg',
    'assets/images/anton18.jpg',
    'assets/images/anton19.jpg',
    'assets/images/anton20.jpg',
  ];

  // 控制滑動頁面
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _imageIndex.value, // ✅ 修正：要加底線
    );
  }

  @override
  void dispose() {
    _imageIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Image'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _imageIndex,
        builder: _imageBuilder,
      ),
    );
  }

  Widget _imageBuilder(BuildContext context, int index, Widget? child) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[

        // ⭐ 圖片滑動 + 縮放
        PhotoViewGallery.builder(
          itemCount: _images.length,

          // ✅ 必加（關鍵修正）
          builder: (context, index) => _buildItem(context, index),

          pageController: _pageController,
          onPageChanged: _onPageChanged,
          scrollPhysics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),

        // ⭐ 上方頁數顯示
        Positioned(
          top: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${index + 1} / ${_images.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 每一頁圖片設定
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: AssetImage(_images[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 0.6,
      maxScale: PhotoViewComputedScale.covered * 2,
    );
  }

  // 滑動時更新 index
  void _onPageChanged(int index) {
    _imageIndex.value = index;
  }
}
