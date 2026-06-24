import 'package:flutter/material.dart';
// ⚠️ 請確保這裡的引入路徑與你的專案結構一致
import 'package:my_first_app/20260610_rocket_delivery_home.dart';
import 'package:my_first_app/20260610_product_detail_page.dart';

/// =========================================================================
/// 搜尋代理類別 (Product Search Delegate)
/// =========================================================================
class ProductSearchDelegate extends SearchDelegate<int?> {
  // 1. 接收首頁完整的商品列表
  final List<Product> allProducts;

  // 🛒【修正關鍵】：必須在這裡宣告 currentCartCount 變數，首頁傳進來的數字才能被存住
  int currentCartCount;

  // 2. 構造函數：確保這裡有寫入 required this.currentCartCount
  ProductSearchDelegate({
    required this.allProducts,
    required this.currentCartCount, // 👈 加上這行，截圖中的紅線就會瞬間消失！
  });

  /// 搜尋列右側的按鈕：清空文字
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  /// 搜尋列左側的按鈕：返回主頁（將最新的購物車數量傳回首頁）
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // 🚀 關閉搜尋頁面時，將最新的數量回傳給首頁
        close(context, currentCartCount);
      },
    );
  }

  /// 使用者按下鍵盤「搜尋」鍵後，展示的搜尋結果列表
  @override
  Widget buildResults(BuildContext context) {
    // 根據關鍵字過濾商品
    final results = allProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          '找不到相關商品，換個關鍵字試試看吧！',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                product.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      color: Color(0xFFE52525),
                      size: 14,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '火箭速配',
                      style: TextStyle(
                        color: Color(0xFFE52525),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '元 ${product.price}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            // 右側直接加購按鈕
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0073E6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                currentCartCount++; // 點擊直接增加內部計數
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已將 ${product.title} 加入購物車！'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text(
                '加入',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              // 點擊卡片進入詳情頁
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: product,
                    currentCartCount: currentCartCount,
                  ),
                ),
              ).then((returnedCount) {
                if (returnedCount != null && returnedCount is int) {
                  currentCartCount = returnedCount;
                }
              });
            },
          ),
        );
      },
    );
  }

  /// 使用者在打字時即時顯示的聯想字與熱門標籤
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      final List<String> hotSearches = ['草莓', '衛生紙', '燕麥奶', '微波爐', '辦公椅'];
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '熱門關鍵字',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hotSearches.map((keyword) {
                return ActionChip(
                  backgroundColor: Colors.grey[200],
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    keyword,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  onPressed: () {
                    query = keyword;
                    showResults(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    final suggestions = allProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            query = product.title;
            showResults(context);
          },
        );
      },
    );
  }
}
