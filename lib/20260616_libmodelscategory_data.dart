import 'package:flutter/material.dart';

/// =========================================================================
/// 📂 商品分類頁面 (CategoryPage)
/// 採用經典的「左右連動雙欄版面」，提升使用者的尋找效率
/// =========================================================================
class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // 記錄目前選中的主分類索引值
  int _selectedMainMenuIndex = 0;

  // 模擬電商分類資料結構
  final List<Map<String, dynamic>> _categoriesData = [
    {
      'mainTitle': '火箭直送',
      'subCategories': ['生鮮食品', '飲料/零食', '日用品', '廚房廚具'],
    },
    {
      'mainTitle': '美妝服飾',
      'subCategories': ['保養彩妝', '男女時裝', '鞋包配飾', '運動戶外'],
    },
    {
      'mainTitle': '3C家電',
      'subCategories': ['手機/平板', '電腦周邊', '視聽家電', '生活家電'],
    },
    {
      'mainTitle': '母嬰玩具',
      'subCategories': ['尿布/濕紙巾', '嬰幼兒食品', '玩具/模型', '童裝'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '商品分類',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Row(
        children: [
          /// 👈 左側欄：主分類導覽列 (佔 1/4 寬度)
          Container(
            width: 100,
            color: const Color(0xFFF5F5F5), // 淺灰色底色做出視覺分隔
            child: ListView.builder(
              itemCount: _categoriesData.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedMainMenuIndex;
                return GestureDetector(
                  onTap: () {
                    // 點擊時切換右側內容，透過 setState 重新渲染
                    setState(() {
                      _selectedMainMenuIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    // 選中時背景變為純白，並加上左側藍色高亮條
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: isSelected
                          ? const Border(
                              left: BorderSide(
                                color: Color(0xFF0073E6),
                                width: 4,
                              ),
                            )
                          : null,
                    ),
                    child: Text(
                      _categoriesData[index]['mainTitle'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF0073E6)
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),

          /// 👉 右側欄：子分類網格面板 (自動填滿剩餘空間)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 當前大分類的標題提示
                  Text(
                    _categoriesData[_selectedMainMenuIndex]['mainTitle'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const Divider(height: 24),

                  // 子分類網格清單
                  Expanded(
                    child: GridView.builder(
                      itemCount:
                          _categoriesData[_selectedMainMenuIndex]['subCategories']
                              .length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 一橫排顯示 3 個項目
                            childAspectRatio: 0.8, // 寬高比，預留空間給文字與圖示
                            crossAxisSpacing: 12, // 欄位水平間距
                            mainAxisSpacing: 12, // 欄位垂直間距
                          ),
                      itemBuilder: (context, index) {
                        final subName =
                            _categoriesData[_selectedMainMenuIndex]['subCategories'][index];
                        return GestureDetector(
                          onTap: () {
                            // TODO: 點擊子分類跳轉至商品列表頁
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('進入 $subName 專區')),
                            );
                          },
                          child: Column(
                            children: [
                              // 模擬分類圖示容器
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.category_outlined,
                                      color: Color(0xFF0073E6),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 分類名稱
                              Text(
                                subName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
