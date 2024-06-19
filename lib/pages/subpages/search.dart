import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'create.dart';


class Book {
  final String title;
  final String year;
  final String author;
  final String abstract;

  Book(
      {required this.title,
      required this.year,
      required this.author,
      required this.abstract});
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    return Book(
      title: volumeInfo['title'],
      year: volumeInfo['publishedDate'] ?? 'Unknown',
      author: volumeInfo['authors']?.join(', ') ?? 'Unknown',
      abstract: volumeInfo['description'] ?? 'No description available',
    );
  }
}

class BookListTile extends StatelessWidget {
  final Book book;


  const BookListTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.year} - ${book.author}'),
      trailing: IconButton(
        onPressed: () {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateBookPage(
                        data: book,
                      )));
        },
        icon: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final TextEditingController _queryController = TextEditingController();
  List<Book> _books = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerca un libro'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _queryController,
              onSubmitted: (query) {
                _searchBooks(query);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      _searchBooks(_queryController.text);
                    },
                    icon: const Icon(Icons.search_rounded)),
                hintText: "Cerca con Google Books",
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return BookListTile(book: _books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchBooks(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=30'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      setState(() {
        _books = items.map((item) => Book.fromJson(item)).toList();
      });
    } else {
      // Handle error
    }
  }
}
