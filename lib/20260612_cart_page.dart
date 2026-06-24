import 'package:flutter/material.dart';
import 'package:my_first_app/20260610_rocket_delivery_home.dart'; // 引入 Product 模型

/// =========================================================================
/// 1. 購物車條目模型 (Cart Item Model)
/// =========================================================================
class CartItem {
  final Product product; // 包含商品的圖片、標題、單價等資訊
  int quantity; // 使用者購買的數量

  CartItem({
    required this.product,
    this.quantity = 1, // 預設加購數量為 1
  });
}

/// =========================================================================
/// 2. 購物車頁面 StatefulWidget
/// =========================================================================
class CartPage extends StatefulWidget {
  // 接收從前一個頁面傳過來的「當前購物車內所有商品條目清單」
  final List<CartItem> initialCartItems;

  const CartPage({super.key, required this.initialCartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 建立一個內部維護的變數，用來承接並動態修改購物車內容
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    // 初始化資料：複製一份傳進來的清單，避免直接改動造成非預期的 Bug
    _cartItems = List.from(widget.initialCartItems);
  }

  /// 📐 【進階邏輯：動態計算總金額】
  /// 將價格字串（例如 "2,990"）去掉逗號，轉換成數字後乘以數量，累加出總金額
  int _calculateTotalPrice() {
    int total = 0;
    for (var item in _cartItems) {
      // 因為你的欄位通通不可為空，直接勇敢地拿去去掉逗號、轉數字即可！
      int priceInt = int.parse(
        item.product.price.toString().replaceAll(',', ''),
      );
      total += priceInt * item.quantity;
    }
    return total;
  }

  /// 📐 【進階邏輯：計算商品總件數】
  /// 用來同步回傳給首頁的數字氣泡
  int _calculateTotalCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    const coupangBlue = Color(0xFF0073E6);
    const rocketRed = Color(0xFFE52525);
    final int totalPrice = _calculateTotalPrice();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          '購物車',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // 🚀 【關鍵回傳】：當點擊左上角返回時，把最新的購物車清單打包丟回首頁
            Navigator.pop(context, _cartItems);
          },
        ),
      ),
      // 使用 WillPopScope 確保使用者按實體返回鍵時也能順利回傳資料
      body: PopScope(
        canPop: false, // 攔截預設返回
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // 🚀 觸發自定義返回，打包最新狀態
          Navigator.pop(context, _cartItems);
        },
        child: _cartItems.isEmpty
            ? _buildEmptyCart() // 如果購物車空空如也，顯示提示畫面
            : Column(
                children: [
                  // 1. 頂部免運進度條提示（電商必備小心機）
                  _buildShippingTip(totalPrice),

                  // 2. 購物車商品列表（支援滑動刪除與數量加減）
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];

                        // 🌟 Dismissible 組件：實作高級感滿滿的「向左滑動刪除」功能
                        return Dismissible(
                          key: Key(item.product.title + index.toString()),
                          direction: DismissDirection.endToStart, // 只能從右往左滑
                          background: Container(
                            color: rocketRed,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              _cartItems.removeAt(index); // 從記憶體中移除該商品
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.product.title} 已從購物車移除'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: _buildCartCard(item, rocketRed, coupangBlue),
                        );
                      },
                    ),
                  ),

                  // 3. 底部結帳總金額區塊
                  _buildCheckoutSection(totalPrice, coupangBlue, rocketRed),
                ],
              ),
      ),
    );
  }

  /// 📦 畫面元件：空購物車提示
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            '您的購物車空空如也',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 畫面元件：運費提示列
  Widget _buildShippingTip(int totalPrice) {
    const threshold = 499; // 假設 499 元免運
    bool isFree = totalPrice >= threshold;

    return Container(
      width: double.infinity,
      color: isFree ? Colors.green[50] : Colors.blue[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            isFree ? Icons.check_circle : Icons.info_outline,
            color: isFree ? Colors.green : Colors.blue,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isFree
                ? '已達免運門檻！享受火箭速配免運費'
                : '再買 \${threshold - totalPrice} 元即可享【火箭速配】免運費！',
            style: TextStyle(
              color: isFree ? Colors.green[800] : Colors.blue[800],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 畫面元件：精美商品卡片與數量控制
  Widget _buildCartCard(CartItem item, Color rocketRed, Color coupangBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品小縮圖
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // 商品標題與價格
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.rocket_launch, color: rocketRed, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '火箭速配',
                        style: TextStyle(
                          color: rocketRed,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '元 ${item.product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // 右側數量控制按鈕組 ( + / - )
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      // 減號按鈕
                      IconButton(
                        constraints: const BoxConstraints(
                          maxWidth: 36,
                          maxHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) {
                              item.quantity--; // 數量大於 1 則直接扣減
                            } else {
                              _cartItems.remove(item); // 減到 0 就直接從購物車剔除
                            }
                          });
                        },
                      ),
                      // 數量顯示
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // 加號按鈕
                      IconButton(
                        constraints: const BoxConstraints(
                          maxWidth: 36,
                          maxHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          setState(() {
                            item.quantity++; // 數量遞增
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📦 畫面元件：底部結帳金額欄位與收據彈窗
  Widget _buildCheckoutSection(
    int totalPrice,
    Color coupangBlue,
    Color rocketRed,
  ) {
    int shippingFee = totalPrice >= 499 ? 0 : 60; // 計算運費

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '商品總金額：',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                '元 $totalPrice',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '火箭運費：',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                shippingFee == 0 ? '免運費' : '元 $shippingFee',
                style: TextStyle(
                  fontSize: 14,
                  color: shippingFee == 0 ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '總計結帳金額：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '元 ${totalPrice + shippingFee}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: rocketRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 💳 大大的結帳按鈕
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: coupangBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _showCheckoutDialog(totalPrice + shippingFee),
              child: Text(
                '總共 ${_calculateTotalCount()} 件商品 - 確認結帳',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 彈窗元件：模擬結帳成功收據
  void _showCheckoutDialog(int finalPay) {
    showDialog(
      context: context,
      barrierDismissible: false, // 必須點擊關閉按鈕才能關閉
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 8),
            Text(
              '訂單成立成功！',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          '感謝您的訂購！我們已收到您的款項共 元 $finalPay，酷朋物流火箭司機正在火速備貨中，預計明天送達指定地點！🚀',
          textAlign: TextAlign.center,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                // 結帳成功，清空內部購物車，關閉彈窗並返回首頁
                setState(() {
                  _cartItems.clear();
                });
                Navigator.pop(context); // 關閉彈窗
                Navigator.pop(context, _cartItems); // 帶著空購物車回首頁
              },
              child: const Text(
                '太棒了，繼續購物！',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
