import 'package:flutter/material.dart';
import 'package:my_first_app/20260609_name_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences MVVM V3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();

  // 實例化大腦（ViewModel）
  final NameViewModel _viewModel = NameViewModel();

  @override
  void initState() {
    super.initState();
    // 透過 ViewModel 讀取資料，並在資料撈完後把文字塞入輸入框
    _viewModel.loadSavedName().then((_) {
      _nameController.text = _viewModel.currentName;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _viewModel.dispose(); // 釋放大腦資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('儲存資料 V3 (MVVM 架構)'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        // 使用 AnimatedBuilder 監聽整個 ViewModel 的變化
        body: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 輸入框
                  Container(
                    width: 250,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: '輸入姓名',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  // 儲存按鈕（如果大腦正在載入中，就顯示轉圈圈，避免重複點擊）
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : _buildButton(
                            text: '確認儲存',
                            onPressed: () =>
                                _viewModel.updateName(_nameController.text),
                          ),
                  ),

                  const SizedBox(height: 30),

                  // 顯示結果
                  const Text(
                    '當前儲存狀態：',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),

                  // 根據大腦裡的狀態給予不同的顯示元件
                  _buildStatusDisplay(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 畫面組件：狀態顯示
  Widget _buildStatusDisplay() {
    if (_viewModel.isLoading) {
      return const Text(
        '資料同步中...',
        style: TextStyle(fontSize: 18, color: Colors.orange),
      );
    }
    if (_viewModel.currentName.isEmpty) {
      return const Text(
        '資料庫空空如也',
        style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }
    return Text(
      _viewModel.currentName,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  // 畫面組件：精美按鈕
  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ), // 變成摩登的橢圓形按鈕
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
