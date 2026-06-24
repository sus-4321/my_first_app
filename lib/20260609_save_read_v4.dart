import 'package:flutter/material.dart';
import 'package:my_first_app/20260609_service_locator.dart';
import 'package:my_first_app/20260609_name_view_model_v4.dart';

void main() {
  // 確保 Flutter 機制在非同步啟動前已完全準備就緒
  WidgetsFlutterBinding.ensureInitialized();

  // 啟動中央依賴注入定位器 (註冊全域單例服務)
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences DI V5 Ultimate',
      debugShowCheckedModeBanner: false, // 隱藏右上角的 DEBUG 標籤
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ), // 以泰爾綠為核心生成佈景主題
        useMaterial3: true, // 啟用 Google 現代化的 Material 3 設計規範
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
  // 控制文字輸入框的控制器
  final TextEditingController _nameController = TextEditingController();

  // 直接向中央定位器伸手索取全域共用的狀態大腦
  final NameViewModelV4 _viewModel = locator<NameViewModelV4>();

  @override
  void initState() {
    super.initState();
    // 頁面初次建立時，主動命令大腦去撈取上次存好的舊資料
    _viewModel.loadSavedName().then((_) {
      // 撈完資料後，將舊資料填入輸入框中
      _nameController.text = _viewModel.currentName;
    });
  }

  @override
  void dispose() {
    // 頁面銷毀時釋放輸入框控制器，防堵記憶體洩漏
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 動態取得手機頂部狀態列的高度，防止畫面被鏡頭瀏海遮擋
    final double topPadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 當點擊畫面任何空白處，自動收起虛擬鍵盤
      child: Scaffold(
        backgroundColor: Colors.grey[100], // 將整體底色設為時尚輕工業淡灰色
        body: AnimatedBuilder(
          animation: _viewModel, // 綁定監聽大腦，只要大腦發出通知，下方區塊就會自動重新渲染
          builder: (context, child) {
            return Stack(
              children: [
                // 1. 頂部優雅的雙色漸層背景區塊
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.teal, Colors.tealAccent],
                    ),
                  ),
                ),

                // 頂部客製化導覽列標題
                Positioned(
                  top: topPadding + 15,
                  left: 20,
                  child: const Text(
                    '本地數據同步中心',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // 2. 主要操作區（使用可捲動視圖，防範鍵盤彈出時產生黃黑相間的溢出警告）
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Column(
                      children: [
                        // 上方：操作控制卡片
                        Card(
                          elevation: 4, // 設置卡片立體陰影深度
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // 摩登大圓角
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 25,
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                // 卡片頂部小標題與功能圖示
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal.withOpacity(
                                        0.1,
                                      ),
                                      child: const Icon(
                                        Icons.storage_rounded,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '偏好設定儲存',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '資料將持久化儲存於手機本地端',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black12,
                                  ), // 分隔線
                                ),

                                // 質感化文字輸入框
                                TextField(
                                  controller: _nameController,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: '使用者姓名',
                                    hintText: '請輸入姓名...',
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                      color: Colors.teal,
                                    ), // 左側小圖示
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.teal,
                                        width: 2,
                                      ), // 聚焦時框線變粗變色
                                    ),
                                  ),
                                ),

                                // 動態防禦型錯誤提示：大腦有偵測到錯誤才顯示紅字
                                if (_viewModel.errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            _viewModel.errorMessage,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 20),

                                // 複合型智能按鈕
                                SizedBox(
                                  width: double.infinity, // 讓按鈕寬度撐滿整張卡片，更具操作分量感
                                  height: 50,
                                  child: _viewModel.isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        ) // 正在寫入時轉圈圈防連點
                                      : ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 2,
                                          ),
                                          icon: const Icon(
                                            Icons.save_rounded,
                                            size: 20,
                                          ), // 按鈕內嵌磁碟小圖示
                                          label: const Text(
                                            '儲存並發布同步',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () => _viewModel
                                              .updateName(_nameController.text),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 下方：資料即時同步廣播看板
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wifi_protected_setup_rounded,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '即時廣播狀態看板',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // 調用抽離的動態看板渲染組件
                                _buildStatusDisplay(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 獨立組件：根據大腦的不同數據狀態，動態切換看板內部的視覺元件
  Widget _buildStatusDisplay() {
    // 狀態一：大腦正忙著在背景同步資料
    if (_viewModel.isLoading) {
      return const Column(
        children: [
          SizedBox(height: 10),
          Text(
            '正在寫入快閃記憶體...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // 狀態二：資料庫空空如也，顯示優雅的缺省灰色插畫感文字
    if (_viewModel.currentName.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text(
              '目前本地無資料',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    // 狀態三：成功讀到姓名，渲染出宛如員工識別證的高質感綠色大面板
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05), // 微弱的半透明泰爾綠背景
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.2)), // 淡淡的綠色細邊框
      ),
      child: Column(
        children: [
          const Text(
            'CURRENT USER',
            style: TextStyle(
              fontSize: 11,
              color: Colors.teal,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _viewModel.currentName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
