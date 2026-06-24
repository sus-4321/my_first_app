class Book {
  // =====================
  // 資料庫欄位名稱
  // =====================

  static const String columnTitle = 'title';
  static const String columnAuthor = 'author';
  static const String columnPublisher = 'publisher';
  static const String columnPrice = 'price';

  // =====================
  // 物件屬性
  // =====================

  final String title; // 書名
  final String author; // 作者
  final String publisher; // 出版社
  final int price; // 價格

  // =====================
  // 建構子
  // 建立 Book 物件時一定要輸入
  // =====================

  const Book({
    required this.title,
    required this.author,
    required this.publisher,
    required this.price,
  });

  // =====================
  // 轉成 Map
  // SQLite新增、修改資料時使用
  // =====================

  Map<String, dynamic> toMap() {
    return {
      columnTitle: title,
      columnAuthor: author,
      columnPublisher: publisher,
      columnPrice: price,
    };
  }
}
