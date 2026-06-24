import 'package:flutter/material.dart';

import 'package:my_first_app/database/book.dart';
import 'package:my_first_app/database/book_db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '資料庫範例',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '資料庫範例'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _authorController = TextEditingController();

  final TextEditingController _publisherController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final BookDbHelper _dbHelper = BookDbHelper.instance;

  final ValueNotifier<List<Book>> _booksNotifier = ValueNotifier<List<Book>>(
    <Book>[],
  );

  @override
  void initState() {
    super.initState();
    _loadAllBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _priceController.dispose();
    _booksNotifier.dispose();
    _dbHelper.closeDatabase();
    super.dispose();
  }

  Future<void> _loadAllBooks() async {
    final List<Book> books = await _dbHelper.getAllBooks();

    if (!mounted) return;

    _booksNotifier.value = books;
  }

  Future<void> _insertBook() async {
    final String title = _titleController.text.trim();

    final String author = _authorController.text.trim();

    final String publisher = _publisherController.text.trim();

    final int? price = int.tryParse(_priceController.text.trim());

    if (title.isEmpty || author.isEmpty || publisher.isEmpty || price == null) {
      _showMessage('請完整輸入書名、作者、出版社與正確售價');
      return;
    }

    final Book book = Book(
      title: title,
      author: author,
      publisher: publisher,
      price: price,
    );

    await _dbHelper.insertBook(book);

    await _loadAllBooks();

    _clearInputs();

    _showMessage('已加入書籍');
  }

  Future<void> _queryBooks() async {
    final String keyword = _titleController.text.trim();

    final List<Book> books = await _dbHelper.queryBooksByTitle(keyword);

    if (!mounted) return;

    _booksNotifier.value = books;
  }

  Future<void> _deleteBook() async {
    final String title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('請輸入要刪除的書名');
      return;
    }

    await _dbHelper.deleteBookByTitle(title);

    await _loadAllBooks();

    _clearInputs();

    _showMessage('已刪除書籍');
  }

  void _clearInputs() {
    _titleController.clear();
    _authorController.clear();
    _publisherController.clear();
    _priceController.clear();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _buildTextField(controller: _titleController, labelText: '書名'),
          _buildTextField(controller: _authorController, labelText: '作者'),
          _buildTextField(controller: _publisherController, labelText: '出版社'),
          _buildTextField(
            controller: _priceController,
            labelText: '售價',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildButtonPanel(),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<Book>>(
              valueListenable: _booksNotifier,
              builder: _bookListBuilder,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: body,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 20),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildButtonPanel() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildActionButton(text: '加入', onPressed: _insertBook),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(text: '查詢', onPressed: _queryBooks),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(text: '刪除', onPressed: _deleteBook),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 8,
      ),
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _bookListBuilder(
    BuildContext context,
    List<Book> books,
    Widget? child,
  ) {
    if (books.isEmpty) {
      return const Center(
        child: Text('目前沒有書籍資料', style: TextStyle(fontSize: 20)),
      );
    }

    return ListView.separated(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final Book book = books[index];

        return ListTile(
          title: Text(book.title, style: const TextStyle(fontSize: 20)),
          subtitle: Text(
            '作者：${book.author}\n出版社：${book.publisher}\n售價：${book.price}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
