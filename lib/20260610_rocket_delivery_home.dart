import 'package:flutter/material.dart';

/// =========================================================================
/// 1. 資料模型 (Data Model)
/// =========================================================================
class Product {
  final String title;
  final int price; // 💡 統一使用 int 型態，方便後續加減乘除
  final String imageUrl;
  final String category;
  final bool isRocketDelivery; // 💡 統一名稱，對齊首頁假資料與詳情頁

  Product({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isRocketDelivery,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // 💡 因為 product.price 已經是 int 了，計算總價變得超級簡單！
  int get totalItemPrice {
    return product.price * quantity;
  }
}

/// =========================================================================
/// 2. 主頁面 StatefulWidget
/// =========================================================================
class RocketDeliveryHome extends StatefulWidget {
  const RocketDeliveryHome({super.key});

  @override
  State<RocketDeliveryHome> createState() => _RocketDeliveryHomeState();
}

class _RocketDeliveryHomeState extends State<RocketDeliveryHome>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Product> _displayedProducts = [];

  bool _isFirstLoading = true;
  final int _currentTabIdx = 0;

  /// 🛒 購物車記憶體資料庫 (Cart State)
  final List<CartItem> _myCartList = [];

  int get _cartCount => _myCartList.fold(0, (sum, item) => sum + item.quantity);
  int get _cartTotalPrice =>
      _myCartList.fold(0, (sum, item) => sum + item.totalItemPrice);

  final GlobalKey _cartKey = GlobalKey();

  // 💡 修正：把價格移除單引號與逗號，直接傳入純數字整數
  final List<Product> _baseMockProducts = [
    Product(
      title: '【酷朋直送】高規格微波爐 省電安全',
      price: 2990,
      imageUrl: 'https://picsum.photos/400/300?random=1',
      category: '3c',
      isRocketDelivery: true,
    ),
    Product(
      title: '天然有機頂級衛生紙 24包/箱',
      price: 389,
      imageUrl: 'https://picsum.photos/300/400?random=2',
      category: 'life',
      isRocketDelivery: false,
    ),
    Product(
      title: '無糖高鈣燕麥奶 1000ml X 6入',
      price: 540,
      imageUrl: 'https://picsum.photos/300/300?random=3',
      category: 'food',
      isRocketDelivery: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initLoad() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _addMockData(10);
    if (mounted) setState(() => _isFirstLoading = false);
  }

  void _addMockData(int count) {
    final List<Product> newLoad = List.generate(count, (index) {
      final baseProduct =
          _baseMockProducts[(index + _displayedProducts.length) %
              _baseMockProducts.length];
      return Product(
        title:
            '${baseProduct.title} (品號 #${_displayedProducts.length + index + 1})',
        price: baseProduct.price,
        imageUrl:
            'https://picsum.photos/300/300?random=${_displayedProducts.length + index}',
        category: baseProduct.category,
        isRocketDelivery: baseProduct.isRocketDelivery,
      );
    });
    _displayedProducts.addAll(newLoad);
  }

  /// ➕ 【1. 增加商品數量 / 新增商品】
  void _updateCartAdd(Product product, GlobalKey btnKey) {
    setState(() {
      final existingIndex = _myCartList.indexWhere(
        (item) => item.product.title == product.title,
      );

      if (existingIndex >= 0) {
        _myCartList[existingIndex].quantity++;
      } else {
        _myCartList.add(CartItem(product: product, quantity: 1));
      }
    });

    _runFlyToCartAnimation(btnKey);
  }

  /// ➖ 【2. 減少商品數量】
  void _updateCartReduce(Product product) {
    setState(() {
      final existingIndex = _myCartList.indexWhere(
        (item) => item.product.title == product.title,
      );

      if (existingIndex >= 0) {
        if (_myCartList[existingIndex].quantity > 1) {
          _myCartList[existingIndex].quantity--;
        } else {
          _myCartList.removeAt(existingIndex);
          _showSnackBar('已將商品從購物車移除');
        }
      }
    });
  }

  /// ✏️ 【3. 直接修改商品數量】
  void _updateCartQuantityDialog(CartItem cartItem) {
    final TextEditingController controller = TextEditingController(
      text: cartItem.quantity.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '修改商品數量',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '請輸入數量', suffixText: '件'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final newQty = int.tryParse(controller.text) ?? 0;
              setState(() {
                if (newQty <= 0) {
                  _myCartList.removeWhere(
                    (item) => item.product.title == cartItem.product.title,
                  );
                } else {
                  cartItem.quantity = newQty;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('確定', style: TextStyle(color: Color(0xFF0073E6))),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _runFlyToCartAnimation(GlobalKey btnKey) {
    final RenderBox? btnBox =
        btnKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartBox =
        _cartKey.currentContext?.findRenderObject() as RenderBox?;

    if (btnBox == null || cartBox == null) return;

    final Offset btnOffset = btnBox.localToGlobal(Offset.zero);
    final Offset cartOffset = cartBox.localToGlobal(Offset.zero);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _FlyDotAnimation(
        startOffset: Offset(btnOffset.dx + 20, btnOffset.dy),
        endOffset: Offset(cartOffset.dx + 15, cartOffset.dy + 15),
        onComplete: () => overlayEntry.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  /// 🛍️ 【底部彈出式購物車清單詳情頁】
  void _showCartBottomSheet() {
    // 定義與主頁相同的顏色以供內部使用
    const coupangBlue = Color(0xFF0073E6);
    const rocketRed = Color(0xFFE52525);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '購物車清單 ($_cartCount 件)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_myCartList.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() => _myCartList.clear());
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '清空全部',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                  const Divider(),
                  _myCartList.isEmpty
                      ? const Expanded(
                          child: Center(child: Text('購物車空空如也，快去逛逛吧！')),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _myCartList.length,
                            itemBuilder: (context, index) {
                              final item = _myCartList[index];
                              return ListTile(
                                leading: Image.network(
                                  item.product.imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  item.product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  '\$${item.product.price}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        _updateCartReduce(item.product);
                                        setModalState(() {});
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _updateCartQuantityDialog(item);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: coupangBlue,
                                      ),
                                      onPressed: () {
                                        _updateCartAdd(
                                          item.product,
                                          GlobalKey(),
                                        );
                                        setModalState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const coupangBlue = Color(0xFF0073E6);
    const rocketRed = Color(0xFFE52525);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    const Icon(Icons.rocket_launch, color: rocketRed, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      '火箭速配',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: coupangBlue,
                      ),
                    ),
                    const Spacer(),

                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black87,
                        size: 26,
                      ),
                      onPressed: () {
                        showSearch<List<CartItem>?>(
                          context: context,
                          delegate: ProductSearchDelegate(
                            allProducts: _displayedProducts,
                            currentCart: _myCartList,
                          ),
                        ).then((updatedCart) {
                          if (updatedCart != null) {
                            setState(() {
                              _myCartList.clear();
                              _myCartList.addAll(updatedCart);
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 4),

                    GestureDetector(
                      onTap: _showCartBottomSheet,
                      child: Stack(
                        key: _cartKey,
                        clipBehavior: Clip.none,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black87,
                              size: 26,
                            ),
                          ),
                          if (_cartCount > 0)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: rocketRed,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '$_cartCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isFirstLoading)
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(color: coupangBlue),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _displayedProducts[index];
                    final GlobalKey btnKey = GlobalKey();

                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[100]!),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                if (product.isRocketDelivery)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: rocketRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '🚀 火箭速配',
                                      style: TextStyle(
                                        color: rocketRed,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product.price}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: rocketRed,
                                      ),
                                    ),
                                    SizedBox(
                                      key: btnKey,
                                      height: 26,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: coupangBlue,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () =>
                                            _updateCartAdd(product, btnKey),
                                        child: const Text(
                                          '加入',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: _displayedProducts.length),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _cartCount == 0
          ? null
          : Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showCartBottomSheet,
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_bag, color: coupangBlue),
                        const SizedBox(width: 4),
                        Text(
                          '總計: \$$_cartTotalPrice',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: rocketRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rocketRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showSnackBar('前往結帳功能開發中！'),
                    child: Text('前往結帳 ($_cartCount)'),
                  ),
                ],
              ),
            ),
    );
  }
}

/// =========================================================================
/// 3. 動態微互動組件：拋物線紅點
/// =========================================================================
class _FlyDotAnimation extends StatefulWidget {
  final Offset startOffset;
  final Offset endOffset;
  final VoidCallback onComplete;

  const _FlyDotAnimation({
    required this.startOffset,
    required this.endOffset,
    required this.onComplete,
  });

  @override
  State<_FlyDotAnimation> createState() => _FlyDotAnimationState();
}

class _FlyDotAnimationState extends State<_FlyDotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double dx = Tween<double>(
          begin: widget.startOffset.dx,
          end: widget.endOffset.dx,
        ).evaluate(_animation);
        double dy = Tween<double>(
          begin: widget.startOffset.dy,
          end: widget.endOffset.dy,
        ).evaluate(_animation);
        return Positioned(
          left: dx,
          top: dy,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFE52525),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// =========================================================================
/// 🚀 搜尋頁面代理介面 (ProductSearchDelegate)
/// =========================================================================
class ProductSearchDelegate extends SearchDelegate<List<CartItem>?> {
  final List<Product> allProducts;
  final List<CartItem> currentCart;

  ProductSearchDelegate({required this.allProducts, required this.currentCart});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, currentCart);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final suggestions = allProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text('找不到相關商品，換個關鍵字試試看吧！'));
    }

    return StatefulBuilder(
      builder: (context, setModalState) {
        return ListView.separated(
          itemCount: suggestions.length,
          padding: const EdgeInsets.all(12),
          separatorBuilder: (context, index) => const Divider(height: 16),
          itemBuilder: (context, index) {
            final product = suggestions[index];
            final GlobalKey searchBtnKey = GlobalKey();

            final cartIdx = currentCart.indexWhere(
              (item) => item.product.title == product.title,
            );
            final currentQty = cartIdx >= 0 ? currentCart[cartIdx].quantity : 0;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    color: Color(0xFFE52525),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentQty > 0) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setModalState(() {
                          if (currentCart[cartIdx].quantity > 1) {
                            currentCart[cartIdx].quantity--;
                          } else {
                            currentCart.removeAt(cartIdx);
                          }
                        });
                      },
                    ),
                    Text(
                      '$currentQty',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  IconButton(
                    key: searchBtnKey,
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF0073E6),
                    ),
                    onPressed: () {
                      setModalState(() {
                        if (cartIdx >= 0) {
                          currentCart[cartIdx].quantity++;
                        } else {
                          currentCart.add(
                            CartItem(product: product, quantity: 1),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
