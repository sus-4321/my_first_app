import 'package:flutter/material.dart';
import '20260610_rocket_delivery_home.dart'; // 確保導入了首頁的 Product 模型

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final int currentCartCount; // 接收首頁傳過來的當前購物車數量

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.currentCartCount,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late int _localCartCount; // 詳情頁內部的計數器

  @override
  void initState() {
    super.initState();
    _localCartCount = widget.currentCartCount; // 把首頁傳來的數量當作初始值
  }

  @override
  Widget build(BuildContext context) {
    const coupangBlue = Color(0xFF0073E6);
    const rocketRed = Color(0xFFE52525);

    // 💡 使用 PopScope 可以攔截實體返回鍵或手勢滑動返回，確保數字能帶回去
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _localCartCount); // 返回時把最新的數量丟回去
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            '商品詳情',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _localCartCount); // 點按鈕返回也帶上數量
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
                if (_localCartCount > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: rocketRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$_localCartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品大圖
              Image.network(
                widget.product.imageUrl,
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 💡 檢查點：確保使用的是 isRocket 屬性，判斷火箭速配標籤
                    // 確保使用的是 widget.product.isRocketDelivery
                    if (widget.product.isRocketDelivery)
                      const Row(
                        children: [
                          Icon(Icons.rocket_launch, color: rocketRed, size: 18),
                          SizedBox(width: 4),
                          Text(
                            '火箭速配',
                            style: TextStyle(
                              color: rocketRed,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // 商品標題
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 價格區塊
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        const Text(
                          '元',
                          style: TextStyle(
                            fontSize: 14,
                            color: rocketRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${widget.product.price}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: rocketRed,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, thickness: 1),
                    // 物流說明區塊（外層無 const，允許 withOpacity 動態運算）
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '明日前送達',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '今晚 23:59 前下單，由酷朋火箭物流保證配送。',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // 底部留白避免遮擋
                  ],
                ),
              ),
            ],
          ),
        ),
        // 底部固定導覽列（購買按鈕區）
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // 加進購物車圖標
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // 同步可以加入加購小驚喜功能（或是與點擊立即購買觸發相同累加）
                    setState(() {
                      _localCartCount++;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已將商品加入購物車！當前累計: $_localCartCount 件'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_shopping_cart,
                    color: coupangBlue,
                  ),
                ),
                const SizedBox(width: 12),
                // 立即購買按鈕
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: coupangBlue,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _localCartCount++;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('已將商品加入購物車！當前累計: $_localCartCount 件'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text(
                      '立即購買',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
