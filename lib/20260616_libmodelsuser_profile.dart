import 'package:flutter/material.dart';

/// =========================================================================
/// 👤 會員中心頁面 (ProfilePage)
/// 包含使用者基本資訊、數位資產欄位、訂單狀態追蹤以及常用功能選單
/// =========================================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // 微冷色調的背景底色
      appBar: AppBar(
        title: const Text(
          '我的酷朋',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {}, // 設定按鈕
          ),
        ],
      ),
      body: ListView(
        children: [
          /// 1. 使用者簡介區塊 (頭像與名稱)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                // 圓形大頭貼
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF0073E6).withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF0073E6),
                  ),
                ),
                const SizedBox(width: 16),
                // 使用者名稱與會員等級
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '火箭探險家',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 火箭會員標籤
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0073E6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🚀 火箭 WOW 會員',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 2. 數位資產橫欄 (酷朋幣、優惠券)
          Container(
            color: Colors.white,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                _buildAssetItem('酷朋幣', '1,250 💰', () {}),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade200,
                ), // 分隔線
                _buildAssetItem('優惠券', '3 張 🎟️', () {}),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade200,
                ), // 分隔線
                _buildAssetItem('禮品卡', '0 元', () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),

          /// 3. 訂單狀態追蹤區卡片
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '我的訂單狀態',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 橫向流程進度
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildOrderStatusItem(Icons.payment, '待付款'),
                        _buildOrderStatusItem(
                          Icons.inventory_2_outlined,
                          '準備中',
                        ),
                        _buildOrderStatusItem(
                          Icons.local_shipping_outlined,
                          '配送中',
                        ),
                        _buildOrderStatusItem(
                          Icons.assignment_turned_in_outlined,
                          '已到貨',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// 4. 常用功能清單群組
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias, // 確保 ListTile 點擊水波紋不超出圓角
              child: Column(
                children: [
                  _buildMenuTile(Icons.favorite_border, '我的追蹤清單'),
                  _buildMenuTile(Icons.history, '最近看過的商品'),
                  _buildMenuTile(Icons.location_on_outlined, '收件地址管理'),
                  _buildMenuTile(Icons.credit_card, '酷朋支付管理'),
                  _buildMenuTile(Icons.headset_mic_outlined, '客服中心 / FAQ'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// 🛠️ 輔助元件：資產欄位項目
  Widget _buildAssetItem(String label, String value, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠️ 輔助元件：訂單狀態節點
  Widget _buildOrderStatusItem(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 26),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  /// 🛠️ 輔助元件：選單功能列
  Widget _buildMenuTile(IconData icon, String title) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1), // 用邊界做出極細分隔線
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
    );
  }
}
